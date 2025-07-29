import React from 'react';

const UserList = ({ users, loading, onRefresh }) => {
  const formatDate = (dateString) => {
    try {
      const date = new Date(dateString);
      return date.toLocaleString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      });
    } catch (error) {
      return 'Invalid Date';
    }
  };

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text).then(() => {
      // You could add a toast notification here
      console.log('Copied to clipboard:', text);
    });
  };

  if (loading) {
    return (
      <div>
        <div className="section-header">
          <h2 className="section-title">👥 User List</h2>
        </div>
        <div className="loading">
          <div className="loading-spinner"></div>
          <p>Loading users...</p>
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="section-header">
        <h2 className="section-title">👥 User List</h2>
        <button 
          className="btn refresh-btn" 
          onClick={onRefresh}
          title="Refresh user list"
        >
          🔄 Refresh
        </button>
      </div>

      {/* Statistics */}
      <div className="stats">
        <div className="stats-item">
          <div className="stats-number">{users.length}</div>
          <div className="stats-label">Total Users</div>
        </div>
        <div className="stats-item">
          <div className="stats-number">
            {users.length > 0 ? formatDate(users[0].createdAt).split(',')[0] : 'N/A'}
          </div>
          <div className="stats-label">Latest User Date</div>
        </div>
        <div className="stats-item">
          <div className="stats-number">
            {users.length > 0 ? '✅' : '❌'}
          </div>
          <div className="stats-label">API Status</div>
        </div>
      </div>

      {users.length === 0 ? (
        <div className="empty-state">
          <h3>📭 No Users Found</h3>
          <p>Create your first user using the form above!</p>
          <div style={{ marginTop: '1rem' }}>
            <button className="btn" onClick={onRefresh}>
              🔄 Refresh List
            </button>
          </div>
        </div>
      ) : (
        <>
          <div className="user-count">
            Showing {users.length} user{users.length !== 1 ? 's' : ''} 
            (sorted by creation date, newest first)
          </div>
          
          <div className="user-list">
            {users.map((user, index) => (
              <div key={user.id} className="user-item fade-in">
                <div className="user-name">
                  👤 {user.name}
                </div>
                
                <div className="user-id">
                  🆔 ID: 
                  <span 
                    style={{ 
                      cursor: 'pointer', 
                      marginLeft: '0.5rem',
                      padding: '2px 6px',
                      background: '#f8f9fa',
                      borderRadius: '4px',
                      border: '1px solid #e9ecef'
                    }}
                    onClick={() => copyToClipboard(user.id)}
                    title="Click to copy ID"
                  >
                    {user.id}
                  </span>
                </div>
                
                <div className="user-date">
                  📅 Created: {formatDate(user.createdAt)}
                </div>

                {/* User Index */}
                <div style={{ 
                  position: 'absolute', 
                  top: '10px', 
                  right: '10px', 
                  background: '#667eea',
                  color: 'white',
                  borderRadius: '50%',
                  width: '24px',
                  height: '24px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: '0.8rem',
                  fontWeight: 'bold'
                }}>
                  {index + 1}
                </div>
              </div>
            ))}
          </div>

          {/* Additional Actions */}
          <div style={{ 
            marginTop: '1rem', 
            padding: '1rem', 
            background: '#f8f9fa', 
            borderRadius: '5px',
            textAlign: 'center'
          }}>
            <p style={{ margin: '0 0 1rem 0', color: '#666' }}>
              💡 <strong>Pro Tips:</strong> Click on any User ID to copy it to clipboard
            </p>
            <button 
              className="btn refresh-btn" 
              onClick={onRefresh}
              style={{ margin: 0 }}
            >
              🔄 Refresh Data
            </button>
          </div>
        </>
      )}
    </div>
  );
};

export default UserList;
