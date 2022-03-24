from flask import Flask, jsonify, Response 
import sys
from flask import jsonify
from flask import jsonify
import json
from flask import json


from datetime import datetime

app = Flask(__name__)

@app.route('/date/<birthDate>', methods=['GET', 'POST'])
def birthDate(birthDate):
    
    birthDate = int(float(birthDate))  
    year = datetime.utcnow().year
    ageInMonths = (int(year) - int(birthDate)) * 12
    return str(ageInMonths)