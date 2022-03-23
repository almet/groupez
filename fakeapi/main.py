from typing import Optional
from datetime import datetime

from fastapi import FastAPI

app = FastAPI()
from fastapi.middleware.cors import CORSMiddleware

origins = [
    "http://localhost",
    "http://localhost:8000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origin_regex="http://.*\.*\.*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# We have two different concepts :

# 1. Delivery: The list of available products + conditions and meta info.
# - status (empty, open, waiting_adjustments, waiting_products, waiting_payments, complete)
# - delivery_name
# - handler_name
# - handler_email
# - handler_phone
# - order_before
# - expected_date
# - products [(id, name, description, price), …]
# - discounts ?

@app.get("/delivery/{delivery_id}")
def read_item(delivery_id: int):
    return {
        "status": "open",
        "delivery_name": "Brasserie du Vieux Singe",
        "handler_name" : "Alexis",
        "handler_email": "alexis@vieuxsinge.com",
        "handler_phone": "0674785489",
        "order_before": datetime(year=2022, month=5, day=1),
        "expected_date": datetime(year=2022, month=6, day=16),
        "products": [
            {
                "id" : "vent-se-leve-blanc",
                "name": "Vent se lève Blanc",
                "description": "100% Macabeu,  Nez fruité, fruits blancs. Arômes : Fraicheur, Anis, Finale fumée",
                "price": 12.3,
            },
            {
                "id" : "vin-rouge",
                "name": "Vin Rouge",
                "description": "Une description",
                "price": 9,
            },
        ],
        "discounts": [
            # 10% general discount when the total amount is greater than 500€.
            {
                "type": "general-discount",
                "when": "amount-greater-than",
                "treshold" : "500",
                "discount": "0.1"
            },

            # Different prices depending on the ordered quantities (in units)
            {
                "type": "different-prices",
                "when": "units-greater-than",
                "treshold": "120",
                "prices": {
                    "vent-se-leve-blanc": 10,
                    "vin-rouge": 8
                }
            }
        ],
        "orders": {}
    }

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "q": q}

# 2. Orders : An orer, placed by an entity (individual or group)
# - name
# - phone_number
# - email
# - ordered_products {product_id : quantity, …}

@app.get("/")
def read_root():
    return {"Hello": "World"}

#
# This should be :
# - orderName : String (The name of the )
# - orderBefore : Time.Posix
# - expectedDeliveryDate : Time.Posix
# - products : List Product
