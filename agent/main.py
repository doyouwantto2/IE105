from ollama import chat;
from ollama import ChatResponse;

message = [{
    "role": "system", 
    "content": "You are a good bot",
}];

while True:
    inp = input();

    message.append({
        "role": "user", 
        "content": inp,
    });

    response = chat(
        model="qwen2.5:7b", 
        messages=message,
        stream=True
    );

    reply = "";

    for chunk in response:
        reply += chunk["message"]["content"];

    message.append({
        "role": "assistant",
        "content": reply
    });

    print(reply);



