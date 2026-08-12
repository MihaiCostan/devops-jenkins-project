from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello World FastApi!"}

@app.get("/health")
def health_check():
    return {"status": "UP"}

@app.get("/sum")
def get_sum(a: float, b: float):
    return {"result": a + b}

@app.get("/div")
def get_div(a: float, b: float):
    return {"result": a / b}