const express = require('express');
const nearAPI = require('near-api-js');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const app = express();
app.use(bodyParser.json()); // to parse JSON bodies

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/taskDB', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

// Define a schema and model for user tasks
const userTaskSchema = new mongoose.Schema({
    userId: { type: String, unique: true }, // Ensure unique usernames
    password: String, // Add password field
    streakCount: Number,
    lastCompleted: String,
    inventory: [{
        rewardId: String,
        transactionId: String
    }], // Array of reward objects
});

const UserTask = mongoose.model('UserTask', userTaskSchema);

// Configure NEAR connection
const nearConfig = {
    networkId: 'testnet',
    nodeUrl: 'https://rpc.testnet.near.org',
    keyStore: new nearAPI.keyStores.InMemoryKeyStore()
};

async function initNear() {
    const near = await nearAPI.connect({ deps: { keyStore: nearConfig.keyStore }, ...nearConfig });
    const account = await near.account('dreamy.testnet');
    const contract = new nearAPI.Contract(account, 'dreamy.testnet', {
        viewMethods: ['getTasks', 'getLeaderboard'],
        changeMethods: ['addTask', 'completeTask', 'addReward'],
    });
    return contract;
}

let contract;
initNear().then(c => contract = c);

app.get('/', (req, res) => {
    res.send('Hello, World!');
});

const port = 3000;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

// Route to add a task
app.post('/addTask', async (req, res) => {
    const { taskName } = req.body;
    await contract.addTask({ taskName });
    res.send('Task added successfully');
});

// Route to handle inventory
app.post('/inventory', async (req, res) => {
    const { rewardId } = req.body;
    res.send('Reward added to inventory');
});

// Route to get leaderboard
app.get('/leaderboard', async (req, res) => {
    try {
        const users = await UserTask.find();
        const leaderboard = users.map(user => ({
            userId: user.userId,
            inventory: user.inventory // Contains rewardId and transactionId
        }));

        res.json(leaderboard);
    } catch (error) {
        console.error('Error fetching leaderboard:', error);
        res.send('Error fetching leaderboard');
    }
});

// Route to get todo list
app.get('/todo', async (req, res) => {
    const tasks = await contract.getTasks();
    res.json(tasks);
});

// Route to complete a task and update streak count
app.post('/completeTask', async (req, res) => {
    const { userId } = req.body;

    // Find the user's task data or create a new entry if it doesn't exist
    let userTaskData = await UserTask.findOne({ userId });

    if (!userTaskData) {
        userTaskData = new UserTask({
            userId: userId,
            password: "", // Initialize password to an empty string for new users
            streakCount: 0,
            lastCompleted: null,
            inventory: []
        });
    }

    const currentDate = new Date().toISOString().split('T')[0]; // Get current date in YYYY-MM-DD 
    const lastCompletedDate = userTaskData.lastCompleted;

    if (lastCompletedDate && (new Date(currentDate) - new Date(lastCompletedDate)) > 86400000) {
        userTaskData.streakCount = 1; // Reset streak to 1
    } else {
        userTaskData.streakCount++;
    }

    userTaskData.lastCompleted = currentDate; 

    if (userTaskData.streakCount % 7 === 0) {
        // Select a random animal as reward
        const animals = [
            'Cat', 'Dog', 'Rabbit', 'Hamster', 'Goldfish', 'Parrot', 'Turtle',
            'Frog', 'Lizard', 'Snake', 'Hedgehog', 'Guinea Pig', 'Ferret',
            'Chinchilla', 'Gerbil', 'Budgie', 'Canary', 'Lovebird', 'Finch', 'Mouse'
        ];
        const randomIndex = Math.floor(Math.random() * animals.length);
        const rewardId = animals[randomIndex];

        // Add reward and capture transaction ID
        try {
            const result = await contract.addReward({ userId, rewardId });
            const transactionId = result.transaction.hash; // Capture the transaction ID

            // Add reward with transaction ID to the inventory
            userTaskData.inventory.push({ rewardId, transactionId });
        } catch (error) {
            console.error('Error adding reward:', error);
            return res.send('Error adding reward');
        }
    }

    await userTaskData.save();

    res.send('Task completed successfully');
});

// Route to handle user signup
app.post('/signup', async (req, res) => {
    const { userId, password } = req.body;

    // Check if the username already exists
    const existingUser = await UserTask.findOne({ userId });

    if (existingUser) {
        return res.send('Username already exists. Please choose a different username.');
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user with the hashed password
    const newUser = new UserTask({
        userId,
        password: hashedPassword,
        streakCount: 0,
        lastCompleted: null,
        inventory: []
    });

    await newUser.save();

    res.send('Signup successful');
});

// Route to handle user login
app.post('/login', async (req, res) => {
    const { userId, password } = req.body;

    // Find the user by username
    const user = await UserTask.findOne({ userId });

    if (!user) {
        return res.send('Username does not exist. Please sign up first.');
    }

    // Compare the provided password with the stored hashed password
    const isPasswordCorrect = await bcrypt.compare(password, user.password);

    if (!isPasswordCorrect) {
        return res.send('Incorrect password. Please try again.');
    }

    res.send('Login successful');
});
