import React, { useState } from 'react';

const CreateUser = ({ onCreateUser }) => {
  const [name, setName] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [localError, setLocalError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validate input
    if (!name.trim()) {
      setLocalError('Please enter a name');
      return;
    }

    if (name.trim().length < 2) {
      setLocalError('Name must be at least 2 characters long');
      return;
    }

    setIsSubmitting(true);
    setLocalError(null);

    try {
      const result = await onCreateUser({ name: name.trim() });
      
      if (result.success) {
        // Clear form on success
        setName('');
        setLocalError(null);
      } else {
        setLocalError(result.error);
      }
    } catch (error) {
      setLocalError('An unexpected error occurred');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleClear = () => {
    setName('');
    setLocalError(null);
  };

  return (
    <div>
      <div className="section-header">
        <h2 className="section-title">➕ Create New User</h2>
      </div>

      {localError && (
        <div className="error">
          <strong>Validation Error:</strong> {localError}
        </div>
      )}

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="userName">
            User Name <span style={{ color: 'red' }}>*</span>
          </label>
          <input
            type="text"
            id="userName"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Enter user name (e.g., John Doe)"
            disabled={isSubmitting}
            maxLength={100}
          />
          <small style={{ color: '#666', fontSize: '0.85rem' }}>
            Enter a name between 2-100 characters
          </small>
        </div>

        <div className="form-actions">
          <button 
            type="submit" 
            className="btn"
            disabled={isSubmitting || !name.trim()}
          >
            {isSubmitting ? (
              <>
                <span className="loading-spinner"></span>
                Creating...
              </>
            ) : (
              '🚀 Create User'
            )}
          </button>

          <button 
            type="button" 
            className="btn clear-btn"
            onClick={handleClear}
            disabled={isSubmitting}
          >
            🗑️ Clear
          </button>
        </div>
      </form>

      <div style={{ marginTop: '1rem', fontSize: '0.9rem', color: '#666' }}>
        <p>
          <strong>💡 Tips:</strong>
        </p>
        <ul style={{ marginLeft: '1rem' }}>
          <li>Names can contain letters, numbers, spaces, and special characters</li>
          <li>Each user gets a unique UUID automatically</li>
          <li>Creation timestamp is recorded automatically</li>
        </ul>
      </div>
    </div>
  );
};

export default CreateUser;
