var web3;

async function Connect() {
    if (window.ethereum) {
        try {
            // Request account access
            await window.ethereum.request({ method: 'eth_requestAccounts' });

            // Create a new Web3 instance
            web3 = new Web3(window.ethereum);

            console.log("Connected to MetaMask!");
        } catch (error) {
            console.error("User denied account access or error occurred:", error);
        }
    } else if (window.web3) {
        // Fallback for older MetaMask versions
        web3 = new Web3(window.web3.currentProvider);
        console.log("Connected to legacy MetaMask!");
    } else {
        console.error("MetaMask not detected. Please install it.");
    }
}
