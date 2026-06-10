"""
Run the Flask application
"""
if __name__ == '__main__':
    # Import inside main to avoid circular imports
    from FlaskWebProject1 import app
    app.run(host='127.0.0.1', port=5000, debug=True)
