const express = require ("express");
const app = express();  
const port = process.env.PORT || 3000;
const message = process.env.MESSAGE || "Hello world!"

    app.get("/", (req, res) => {
        res.send(message);
    });

    app.get("/health", (req, res) => {
        res.sendStatus(200);
      });

    app.listen(port, () => {
        console.log(`Server is running on port ${port}`)
    })