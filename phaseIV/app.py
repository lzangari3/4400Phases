from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

### 
#
# Here are all of the procedures
#
###

# Add Airplane Form
@app.route("/add airplane")
def add_airplane():
    return render_template("add_airplane.html")

# Add Person Form
@app.route("/add person")
def add_person():
    return render_template("add_person.html")

# Assign Pilot Form
@app.route("/assign Pilot")
def assign_pilot():
    return render_template("assign_pilot.html")

# Flight Landing Form
@app.route("/flight landing")
def flight_landing():
    return render_template("flight_landing.html")

# Flight Takeoff Form
@app.route("/flight takeoff")
def flight_takeoff():
    return render_template("flight_takeoff.html")

# Grant or revoke pilot license Form
@app.route("/grant or revoke pilot license")
def grant_revoke_pilot():
    return render_template("grant_or_revoke_pilot_license.html")

# offer flight Form
@app.route("/offer flight")
def offer_flight():
    return render_template("offer_flight.html")

# passengers board Form
@app.route("/passengers board")
def passengers_board():
    return render_template("passengers_board.html")

# passengers disembark Form
@app.route("/passengers disembark")
def passengers_disembark():
    return render_template("passengers_disembark.html")

# recycle crew Form
@app.route("/recycle crew")
def recycle_crew():
    return render_template("recycle_crew.html")

# retire flight Form
@app.route("/retire flight")
def retire_flight():
    return render_template("retire_flight.html")

# simulation cycle Form
@app.route("/simulation cycle")
def simulation_cycle():
    return render_template("simulation_cycle.html")

### 
# 
# Here are all of the methods for submitting
# 
### 

# Add Airplane Procedure
@app.route("/add airplane", methods=['POST'])
def submit_add_airplane():

    # All of the parameters to the procedure
    speed = request.form['speed']
    maintained = request.form['maintained']
    airlineId = request.form['airlineId']
    neo = request.form['neo']
    tailNum = request.form['tailNum']
    locationId = request.form['locationId']
    model = request.form['model']   
    seatCap = request.form['seatCap']
    planeType = request.form['planeType'] 

    # This needs to be configured to the database
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.callproc('add_person', [speed, maintained, airlineId, neo, tailNum, locationId, model, seatCap, planeType])
        conn.commit()
    except mysql.connector.Error as e:
        return f"Database error: {e}"
    finally:
        conn.close()

    return redirect(url_for('index'))

# Add Person Procedure
@app.route("/add person", methods=['POST'])
def submit_add_person():
    pass

# Assign Pilot Procedure
@app.route("/assign Pilot", methods=['POST'])
def submit_assign_pilot():
    pass

# Flight Landing Procedure
@app.route("/flight landing", methods=['POST'])
def submit_flight_landing():
    pass

# Flight Takeoff Procedure
@app.route("/flight takeoff", methods=['POST'])
def submit_flight_takeoff():
    pass

# Grant or revoke pilot license Procedure
@app.route("/grant or revoke pilot license", methods=['POST'])
def submit_grant_revoke_pilot():
    pass

# offer flight Procedure
@app.route("/offer flight", methods=['POST'])
def submit_offer_flight():
    pass

# passengers board Procedure
@app.route("/passengers board", methods=['POST'])
def submit_passengers_board():
    pass

# passengers disembark Procedure
@app.route("/passengers disembark", methods=['POST'])
def submit_passengers_disembark():
    pass

# recycle crew Procedure
@app.route("/recycle crew", methods=['POST'])
def submit_recycle_crew():
    pass

# retire flight Procedure
@app.route("/retire flight", methods=['POST'])
def submit_retire_flight():
    pass

# simulation cycle Procedure
@app.route("/simulation cycle", methods=['POST'])
def submit_simulation_cycle():
    pass

### The Views will be down here ###