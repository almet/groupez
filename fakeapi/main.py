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
                "id" : "ST75",
                "name": "Souffle Tropical 75cl",
                "description": "American Wheat Citra / Mosaic. Bière de blé assez légère et fruitée, notes de fruits exotiques. 4,5°alc",
                "price": 5,
            },
            {
                "id" : "NM75",
                "name": "Nouveau Monde 75cl",
                "description": "American Pale Ale Chinook / Cascade. Amertume marquée, plutôt sur l'agrume. 5°alc",
                "price": 5,
            },
            {
                "id" : "EPT75",
                "name": "En Pleine Tempête 75cl",
                "description": "London Bitter, assez légère, notes de pain grillé. 5°alc",
                "price": 5,
            },
            {
                "id" : "EQD75",
                "name": "L'Eau Qui Dort 75cl",
                "description": "Stout à la vanille / Bière noire sur des aromes de torréfaction (Café / Cacao) avec du sucre résiduel et de la vanille. 6°alc",
                "price": 6,
            },
        ],
        "discounts": [
            # 10% general discount when the total amount is greater than 500€.
            {
                "type": "general-discount",
                "rules": {
                    "when": "amount-greater-than",
                    "treshold" : "240",
                    "percentage": "10"
                }
            }

            # Different prices depending on the ordered quantities (in units)
            # ,{
            #     "type": "different-prices",
            #     "when": "units-greater-than",
            #     "treshold": "60",
            #     "prices": {
            #         "ST75": 4,
            #         "NM75": 4,
            #         "EPT75": 4,
            #         "EQD75": 5
            #     }
            # }
        ],
        "orders": [{

                "meta" {
                    "phone_number": "0674785489"
                    , "email": "alexis@notmyidea.org"
                    , "last_update": datetime(year=2022, month=3, day=23, hour=23, minute=59),
                },
                "quantities": {
                    "ST75": 10
                    ,"NM75": 10
                }
            }
            ]
        }
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
