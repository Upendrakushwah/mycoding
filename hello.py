import random 
subjects = [
    "aadi",
    "abhay",
    "jaaadu",
    "prince",
    "mayank",
    "akash",
    "mani"
    ]
actions =[
    "running",
    "walking",
    "throw",
    "bath",
    "sing",
    "dancing"
]

places_or_things =[
    "is gay",
    " is cute",
    "the bodybuilder",
    "knows cricket",
    "at riverside",
    "is jhaantu",
    "is gymer",
]

while True :
    subject = random.choice(subjects)
    action = random.choice(actions)
    places_or_thing = random.choice(places_or_things)
    
    headline = f"BREAKING  NEWS: {subject} {action} {places_or_thing}"
    print(" \n" + headline)
    
    
    user_input = input("\n do you want another headline?(yes/no) ").strip()
    if user_input == "no":
        break 
    
    print ("\n thank you")
    