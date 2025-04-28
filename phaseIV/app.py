from flask import Flask, render_template
from db_utils import query_view
import os

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

# Renders static pages
@app.route('/page/<page_name>')
def render_static_page(page_name):

    # First, try to render as a procedure
    procedure_path = os.path.join('procedures', f"{page_name}.html")
    if os.path.exists(os.path.join(app.template_folder or 'templates', procedure_path)):
        return render_template(procedure_path)

    # Otherwise, try to render as a view
    view_path = os.path.join('views', f"{page_name}.html")
    if os.path.exists(os.path.join(app.template_folder or 'templates', view_path)):
        return render_template(view_path)

    # If neither exists, return 404
    return f"<h2>Page '{page_name}' Not Found</h2>", 404

### 
# 
# Here are all of the methods for submitting
# 
### 

# Add Airplane Procedure
@app.route("/add airplane", methods=['POST'])
def submit_add_airplane():

    ## All of the parameters to the procedure
    #speed = request.form['speed']
    #maintained = request.form['maintained']
    #airlineId = request.form['airlineId']
    #neo = request.form['neo']
    #tailNum = request.form['tailNum']
    #locationId = request.form['locationId']
    #model = request.form['model']   
    #seatCap = request.form['seatCap']
    #planeType = request.form['planeType'] 

    ## This needs to be configured to the database
    #conn = get_connection()
    #cursor = conn.cursor()
    #try:
        #cursor.callproc('add_person', [
            #speed, maintained, airlineId, neo, 
            #tailNum, locationId, model, seatCap, planeType
        #])

        #conn.commit()
    #except mysql.connector.Error as e:
        #return f"Database error: {e}"
    #finally:
        #conn.close()

    #return redirect(url_for('index'))

    pass

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

### 
# 
# The Views will be down here 
# 
###

# To-Do:
# - Properly format the JSON files so that they can be 

@app.route('/view/flights-in-air')
def flights_in_air():
    return query_view("flights_in_the_air")

@app.route('/view/flights-on-ground')
def flights_on_the_ground():
    return query_view("flights_on_the_ground")

@app.route('/view/people-in-air')
def people_in_the_air():
    return query_view("people_in_the_air")

@app.route('/view/people-on-ground')
def people_on_the_ground():
    return query_view("people_on_the_ground")

@app.route('/view/route-summary')
def route_summary():
    return query_view("route_summary")

@app.route('/view/alternative-airports')
def alternative_airports():
    return query_view("alternative_airports")
