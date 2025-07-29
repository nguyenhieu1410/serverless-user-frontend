import React, { useState, useEffect } from 'react';
import axios from 'axios';
import UserList from './components/UserList';
import CreateUser from './components/CreateUser';
import './App.css';

// API Base URL - Replace with your actual API Gateway URL
const API_BASE_URL = process.env.REACT_APP_API_URL || 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/dev';

function App() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);

  // Fetch users from API
  const fetchUsers = async () => {
    try {
      setLoading(true);
      setError(null);
      
      const response = await axios.get(`${API_BASE_URL}/users`);
      
      // Handle the response structure from your API
      if (response.data && response.data.body) {
        setUsers(response.data.body);
      } else {
        setUsers([]);
      }
    } catch (err) {
      console.error('Error fetching users:', err);
      setError('Failed to fetch users. Please check if the API is running.');
      setUsers([]);
    } finally {
      setLoading(false);
    }
  };

  // Create new user
  const createUser = async (userData) => {
    try {
      setError(null);
      setSuccess(null);
      
      const response = await axios.post(`${API_BASE_URL}/users`, userData, {
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.data && response.data.body) {
        // Add new user to the list
        setUsers(prevUsers => [response.data.body, ...prevUsers]);
        setSuccess(`User "${userData.name}" created successfully!`);
        
        // Clear success message after 3 seconds
        setTimeout(() => setSuccess(null), 3000);
        
        return { success: true, user: response.data.body };
      }
    } catch (err) {
      console.error('Error creating user:', err);
      const errorMessage = err.response?.data?.message || 'Failed to create user. Please try again.';
      setError(errorMessage);
      
      // Clear error message after 5 seconds
      setTimeout(() => setError(null), 5000);
      
      return { success: false, error: errorMessage };
    }
  };

  // Load users on component mount
  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <div className="App">
      <div className="container">
        {/* Header */}
        <header className="header">
          <h1>🚀 Serverless User Management</h1>
          <p>Manage users with AWS Lambda, API Gateway, and DynamoDB</p>
        </header>

        {/* Global Messages */}
        {error && (
          <div className="error">
            <strong>Error:</strong> {error}
          </div>
        )}

        {success && (
          <div className="success">
            <strong>Success:</strong> {success}
          </div>
        )}

        {/* Create User Section */}
        <div className="card">
          <CreateUser onCreateUser={createUser} />
        </div>

        {/* User List Section */}
        <div className="card">
          <UserList 
            users={users} 
            loading={loading} 
            onRefresh={fetchUsers}
          />
        </div>

        {/* Footer */}
        <footer style={{ textAlign: 'center', marginTop: '2rem', color: '#666' }}>
          <p>
            API URL: <code>{API_BASE_URL}</code>
          </p>
          <p>
            Built with React + AWS Serverless Architecture
          </p>
        </footer>
      </div>
    </div>
  );
}

export default App;
