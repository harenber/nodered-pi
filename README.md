# nodered-pi
Dockerfile (and additional files) for a Node RED image on the Pi with tcl and a script to read out Grünwelt water softener

- Dockerfile is derived from the original Dockerfile provided by the Node RED people
- Grünwelt script was found in a forum, the link inside the script for the original source

Example to read out some values of a Grünbeck device on a click (change the IP to the one of your softener!):

```json
[
    {
        "id": "46a81f33.93a2f8",
        "type": "ui_text",
        "z": "e1883d2d.c38c08",
        "group": "638865a.1292c9c",
        "order": 2,
        "width": 0,
        "height": 0,
        "name": "",
        "label": "Salzvorrat",
        "format": "{{msg.payload}} Tage",
        "layout": "row-spread",
        "x": 630,
        "y": 640,
        "wires": []
    },
    {
        "id": "9479fe52.70b7c8",
        "type": "bigexec",
        "z": "e1883d2d.c38c08",
        "name": "Salzvorrat",
        "command": "/usr/local/bin/get_gruenbeck.tcl",
        "commandArgs": "192.168.178.143 824  D_A_2_3",
        "minError": 1,
        "minWarning": 1,
        "cwd": "",
        "shell": "",
        "extraArgumentProperty": "",
        "envProperty": "",
        "format": "ascii",
        "limiter": true,
        "payloadIs": "trigger",
        "x": 410,
        "y": 660,
        "wires": [
            [
                "46a81f33.93a2f8"
            ],
            [],
            []
        ]
    },
    {
        "id": "294cfdd2.af8112",
        "type": "bigexec",
        "z": "e1883d2d.c38c08",
        "name": "Wasser vorgestern",
        "command": "/usr/local/bin/get_gruenbeck.tcl",
        "commandArgs": "192.168.178.143 824  D_Y_2_2",
        "minError": 1,
        "minWarning": 1,
        "cwd": "",
        "shell": "",
        "extraArgumentProperty": "",
        "envProperty": "",
        "format": "ascii",
        "limiter": true,
        "payloadIs": "trigger",
        "x": 470,
        "y": 580,
        "wires": [
            [
                "29fb8f5.423fd7",
                "9479fe52.70b7c8"
            ],
            [],
            []
        ]
    },
    {
        "id": "bc642233.1c51c8",
        "type": "bigexec",
        "z": "e1883d2d.c38c08",
        "name": "Wasser gestern",
        "command": "/usr/local/bin/get_gruenbeck.tcl",
        "commandArgs": "192.168.178.143 823 D_Y_2_1",
        "minError": 1,
        "minWarning": 1,
        "cwd": "",
        "shell": "",
        "extraArgumentProperty": "",
        "envProperty": "",
        "format": "ascii",
        "limiter": true,
        "payloadIs": "trigger",
        "x": 440,
        "y": 500,
        "wires": [
            [
                "9242fc6b.5e4a78",
                "294cfdd2.af8112"
            ],
            [],
            []
        ]
    },
    {
        "id": "29fb8f5.423fd7",
        "type": "ui_text",
        "z": "e1883d2d.c38c08",
        "group": "638865a.1292c9c",
        "order": 2,
        "width": 0,
        "height": 0,
        "name": "",
        "label": "Vorgestern",
        "format": "{{msg.payload}} l",
        "layout": "row-spread",
        "x": 670,
        "y": 560,
        "wires": []
    },
    {
        "id": "9242fc6b.5e4a78",
        "type": "ui_text",
        "z": "e1883d2d.c38c08",
        "group": "638865a.1292c9c",
        "order": 1,
        "width": 0,
        "height": 0,
        "name": "",
        "label": "Gestern",
        "format": "{{msg.payload}} l",
        "layout": "row-spread",
        "x": 640,
        "y": 480,
        "wires": []
    },
    {
        "id": "4723fd81.6ff19c",
        "type": "ui_button",
        "z": "e1883d2d.c38c08",
        "name": "",
        "group": "638865a.1292c9c",
        "order": 3,
        "width": 0,
        "height": 0,
        "passthru": false,
        "label": "Update Grünbeck Werte",
        "tooltip": "",
        "color": "",
        "bgcolor": "",
        "icon": "",
        "payload": "0",
        "payloadType": "str",
        "topic": "",
        "x": 210,
        "y": 500,
        "wires": [
            [
                "bc642233.1c51c8"
            ]
        ]
    },
    {
        "id": "638865a.1292c9c",
        "type": "ui_group",
        "z": "",
        "name": "Wasser",
        "tab": "9903024f.776188",
        "order": 4,
        "disp": true,
        "width": "6",
        "collapse": false
    },
    {
        "id": "9903024f.776188",
        "type": "ui_tab",
        "z": "",
        "name": "KBS 75",
        "icon": "dashboard",
        "order": 1,
        "disabled": false,
        "hidden": false
    }
]
```
