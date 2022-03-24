import unittest
import requests
import pytest
import requests_mock

from flask import url_for
from flask_testing import TestCase

from app import app


class TestBase(TestCase):
    def create_app(self):
        config_name = 'testing'
        app.config.update(
            WTF_CSRF_ENABLED=False,
            DEBUG=True
            )
        return app

    def setUp(self):
        print("-----------")

    def tearDown(self):
        print("--------")

class TestMain:
    
    def test_main(self):
        with requests_mock.mock() as m:
            formData = 1986
            formData = str(formData)
            m.post('http://main:5000', formData)

            response = self.client.get(
                url_for('index')
            )
            self.assertIn('birthdate:', response.data)

    def test_prize(self):
        with requests_mock.mock() as m:
            formData = 1986
            formData = str(formData)
            m.post('http://converter:5001/1986')
            response = self.client.get(
                url_for('date', birthDate='420')
            )
            birthDate = 420
            birthDate = str(birthDate)
            m.post('http://prime:5002/420')
            response = self.client.get(
                url_for('date', prime='you are COMPOSITE!')
            )

