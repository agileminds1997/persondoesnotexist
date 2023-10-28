#!/usr/bin/env node

const axios = require('axios');
const fs = require('fs');
const path = require('path');

const downloadImage = async (url, directory, filename) => {
  const response = await axios({
    url,
    method: 'GET',
    responseType: 'stream',
  });

  const imagePath = path.join(directory, filename);

  response.data.pipe(fs.createWriteStream(imagePath));

  return new Promise((resolve, reject) => {
    response.data.on('end', () => {
      resolve(imagePath);
    });

    response.data.on('error', (err) => {
      reject(err);
    });
  });
};

const updateImageNumber = (number) => {
  const filename = 'imageNumber.txt';
  const numberString = number.toString();

  fs.writeFileSync(filename, numberString, 'utf8');
};

const downloadImageFromURL = async () => {
  const directory = './images'; // Change this to your desired directory
  let imageNumber = parseInt(fs.readFileSync('imageNumber.txt', 'utf8'), 10) || 1;
  const imageUrl = 'https://thispersondoesnotexist.com/';
  const filename = `picture_${imageNumber.toString().padStart(3, '0')}.png`;

  // Create the directory if it doesn't exist
  if (!fs.existsSync(directory)) {
    fs.mkdirSync(directory);
  }

  try {
    const downloadedImagePath = await downloadImage(imageUrl, directory, filename);
    console.log(`Image downloaded and saved as ${downloadedImagePath}`);
    imageNumber++;
    updateImageNumber(imageNumber);
  } catch (error) {
    console.error('Error downloading the image:', error);
  }
};

downloadImageFromURL();
