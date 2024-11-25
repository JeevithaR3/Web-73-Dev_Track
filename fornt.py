from flask import Flask, render_template, request, redirect, url_for, session, flash # type: ignore
from pymongo import MongoClient # type: ignore
from werkzeug.security import generate_password_hash, check_password_hash # type: ignore
import secrets
from datetime import timedelta

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)
app.permanent_session_lifetime = timedelta(minutes=30)

# Connect to MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['aadhar360']
users_collection = db['users']

@app.route("/")
def home():
    if "username" in session:
        return redirect(url_for("dashboard"))
    return redirect(url_for("login"))

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        user = users_collection.find_one({"username": username})
        if user and check_password_hash(user["password"], password):
            session["username"] = username
            return redirect(url_for("dashboard"))
        return render_template("user.html", error="Invalid username or password", mode="login")
    return render_template("user.html", mode="login")

@app.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "POST":
        username = request.form["username"]
        email = request.form["email"]
        password = request.form["password"]
        existing_user = users_collection.find_one({"username": username})
        existing_email = users_collection.find_one({"email": email})
        if existing_user:
            return render_template("user.html", error="Username already exists", mode="signup")
        if existing_email:
            return render_template("user.html", error="Email already exists", mode="signup")
        hashed_password = generate_password_hash(password)
        users_collection.insert_one({"username": username, "email": email, "password": hashed_password})
        return redirect(url_for("login"))
    return render_template("user.html", mode="signup")

@app.route("/dashboard")
def dashboard():
    if "username" in session:
        return f"Hello, {session['username']}!"
    return redirect(url_for("login"))

@app.route("/logout")
def logout():
    session.pop("username", None)
    return redirect(url_for("login"))

if __name__ == "__main__":
    app.run(debug=True)
