from flask import Flask, render_template
from datetime import datetime
import mysql.connector

app = Flask(__name__)

@app.route('/')
@app.route('/home')
def home():
    """Renders the home page."""
    return render_template(
        'index.html',
        title='Home Page',
        year=datetime.now().year,
    )

@app.route('/contact')
def contact():
    """Renders the contact page."""
    return render_template(
        'contact.html',
        title='Contact',
        year=datetime.now().year,
        message='Your contact page.'
    )

@app.route('/about')
def about():
    """Renders the about page."""
    return render_template(
        'about.html',
        title='About',
        year=datetime.now().year,
        message='Your application description page.'
    )

# @app.route('/dbtime')
# def dbtime():
    """Get current time from MySQL database using DNS hostname."""
    try:
        conn = mysql.connector.connect(
            host='mysql_server',  # DNS hostname (container name) on custom network
            user='root',
            password='password123',
            database='mysql'
        )
        cursor = conn.cursor()
        cursor.execute("SELECT CURRENT_TIMESTAMP();")
        result = cursor.fetchone()
        cursor.close()
        conn.close()
        
        db_time = result[0] if result else "No result"
        return f"<h1>MySQL Database Time</h1><p>Current time from database: {db_time}</p>"
    except Exception as e:
        return f"<h1>Error connecting to database</h1><p>Error: {str(e)}</p>"

# OLD CODE - COMMENTED OUT (Using simulated database time)
@app.route('/dbtime')
def dbtime_old():
    """Get current time (simulated database time)."""
    from datetime import datetime
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return f"<h1>Server Time</h1><p>Current time: {current_time}</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=False)
