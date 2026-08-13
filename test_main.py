from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "UP"

def test_sum_res():
    response = client.get("/sum?a=5&b=2")
    assert response.status_code == 200
    assert response.json() == {"result": 7.0}

def test_div_res():
    response = client.get("/div?a=7&b=2")
    assert response.status_code == 200
    assert response.json() == {"result": 4.5}