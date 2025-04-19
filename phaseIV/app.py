from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")


### Here are all of the procedures ###

# Add Airplane Procedure
@app.route("/add airplane")
def add_airplane():
    return render_template("add_airplane.html")

# Add Person Procedure
@app.route("/add person")
def add_person():
    return render_template("add_person.html")

# Assign Pilot Procedure
@app.route("/assign Pilot")
def assign_pilot():
    return render_template("assign_pilot.html")

# Flight Landing Procedure
@app.route("/flight landing")
def flight_landing():
    return render_template("flight_landing.html")

# Flight Takeoff Procedure
@app.route("/flight takeoff")
def flight_takeoff():
    return render_template("flight_takeoff.html")

# Grant or revoke pilot license
@app.route("/grant or revoke pilot license")
def grant_revoke_pilot():
    return render_template("grant_or_revoke_pilot_license.html")

# offer flight
@app.route("/offer flight")
def offer_flight():
    return render_template("offer_flight.html")

# passengers board 
@app.route("/passengers board")
def passengers_board():
    return render_template("passengers_board.html")

# passengers disembark 
@app.route("/passengers disembark")
def passengers_disembark():
    return render_template("passengers_disembark.html")

# recycle crew 
@app.route("/recycle crew")
def recycle_crew():
    return render_template("recycle_crew.html")

# retire flight
@app.route("/retire flight")
def retire_flight():
    return render_template("retire_flight.html")

# simulation cycle
@app.route("/simulation cycle")
def simulation_cycle():
    return render_template("simulation_cycle.html")

### The Views will be down here ###