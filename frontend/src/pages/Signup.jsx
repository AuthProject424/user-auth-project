import React from 'react';
import { useNavigate, Link } from 'react-router-dom';

const Signup = () => {
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    // For now, just navigate to confirmation page without any validation
    navigate('/confirmation');
  };

  return (
    <div style={styles.container}>
      <div style={styles.formWrapper}>
        <h1 style={styles.title}>Create Account</h1>
        <form style={styles.form} onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="Username"
            style={styles.input}
          />
          <input
            type="email"
            placeholder="Email"
            style={styles.input}
          />
          <input
            type="password"
            placeholder="Password"
            style={styles.input}
          />
          <button style={styles.button}>
            Sign Up
          </button>
          <p style={styles.loginText}>
            Already have an account? <Link to="/login" style={styles.loginLink}>Login</Link>
          </p>
        </form>
      </div>
    </div>
  );
};

const styles = {
  container: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: '100vh',
    width: '100%',
    backgroundColor: 'white',
  },
  formWrapper: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    padding: '2rem',
    marginTop: '-10rem',
    width: '100%',
    maxWidth: '400px',
  },
  title: {
    fontSize: '2rem',
    color: '#333',
    marginBottom: '2rem',
    textAlign: 'center',
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    width: '100%',
    gap: '1rem',
  },
  input: {
    padding: '1rem',
    borderRadius: '4px',
    border: '1px solid #ccc',
    fontSize: '1rem',
    transition: 'border-color 0.2s ease',
    outline: 'none',
    ':focus': {
      borderColor: '#4A90E2',
    },
  },
  button: {
    padding: '1rem',
    backgroundColor: '#4A90E2',
    color: 'white',
    border: 'none',
    borderRadius: '4px',
    fontSize: '1rem',
    cursor: 'pointer',
    transition: 'background-color 0.2s ease',
    marginTop: '1rem',
    ':hover': {
      backgroundColor: '#357ABD',
    },
  },
  loginText: {
    marginTop: '1rem',
    textAlign: 'center',
    color: '#333',
  },
  loginLink: {
    color: '#007bff',
    textDecoration: 'none',
    cursor: 'pointer',
  },
};

export default Signup;
