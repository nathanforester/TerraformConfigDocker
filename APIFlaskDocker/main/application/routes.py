from flask import Flask
from application import app
import requests
from flask import render_template, request, redirect, url_for
import sys



@app.route('/', methods=['GET', 'POST'])
def index():
    return render_template('index.html')

@app.route('/signUp', methods=['GET', 'POST'])
# def profile():
#     formDataName = request.form.get('name')
#     formDataPasswordA = request.form.get('password')
#     formDataPasswordB = request.form.get('2password')
#     if formDataPasswordA != formDataPasswordB:
#         return redirect(url_for('signUp'))
#     else:
#         #do database logic here
#         return render_template('BirthDate.html')

# @app.route('/signIn')
# def signIn():
#     formDataName = request.form.get('name')
#     formDataPassword = request.form.get('password')
#     #logic to search database and match passwords here, if not return redirect
#     #if successful, return birthdate page

@app.route('/date', methods=['GET', 'POST'])
def date():
    formData = request.form.get('date')
    formData = str(formData)
    birthDate = requests.post('http://converter:5001/date/' + formData)
    print(birthDate.text, file=sys.stderr)
    print(birthDate.text, file=sys.stdout)
    prime = requests.post('http://prime:5002/date/' + formData)
    print(prime.text, file=sys.stderr)
    print(prime.text, file=sys.stdout)
    print(formData, file=sys.stderr)
    print(formData, file=sys.stdout)
    return render_template('convertPrime.html', formData=formData, birthDate=birthDate.text, prime=prime.text)

