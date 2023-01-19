const AWS = require('aws-sdk');

const config = {
  endpoint: process.env.LIARA_ENDPOINT,
  accessKeyId: process.env.LIARA_ACCESS_KEY,
  secretAccessKey: process.env.LIARA_SECRET_KEY,
  region: "default",
}

const client = new AWS.S3(config);



const params = {
  Bucket: process.env.LIARA_BUCKET_NAME,
  Key: "dataset/dataset.RDS"
};


// callback
client.listObjectsV2(params, (err, data) => {
  if (err) console.error(err, err.stack);
  else console.log("success", data);
});

