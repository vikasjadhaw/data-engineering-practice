import pandas as pd

data = {
    "id": [1, 2, 3],
    "name": ["A", "B", "C"],
    "address": ["pune", "mumbai", "pune"]
}

df = pd.DataFrame(data)

print(df)
