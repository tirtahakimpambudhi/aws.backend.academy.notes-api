import newman from "newman";

newman.run({

    collection: "./notes-api-test.postman_collection.json",
    environment: "./notes-api-test.postman_environment.json",
    envVar: [
        {
            "key": "baseUrl",
            "value": process.env.BASE_URL
        },
    ],
    reporters: "cli"
},function (err) {
    if (err) {
        console.error(err?.message);
        throw err;
        return;
    }
    console.log("collection run complete!");
    process.exit(0);
});