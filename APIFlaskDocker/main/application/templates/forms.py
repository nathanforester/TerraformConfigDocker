# from flask import *
# from flask_wtf import FlaskForm
# from wtforms import StringField, SubmitField, SelectField
# from wtforms.validators import DataRequired, ValidationError

# from application import db

# class BirthDate(db.Model): # customise
#     id = db.Column(db.Integer, primary_key=True)
#     birthdate = db.Column(db.String(30), nullable=False)
#     birthDateId = db.Column(db.Integer, db.ForeignKey('name.id'), nullable=True)

# class User(db.Model): # customise
#     id = db.Column(db.Integer, primary_key=True)
#     Name = db.Column(db.String(100))
#     password = db.Column(db.Integer)
#     birthDate = db.relationship('BirthDate', backref='BirthDate')
    

