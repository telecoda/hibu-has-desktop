class ImageLoader extends Thread {

  HibuARObject objToLoad;
  
  ImageLoader(HibuARObject arObject) {
     this.objToLoad = arObject;
  }
  
    void run() {
      
     String apiUrl;
     int imageId = this.objToLoad.ID%6;
    apiUrl = "http://hibu-has.herokuapp.com/boards/"+imageId;
      
    String jsonResponse = httpGet(apiUrl);
    System.out.println(jsonResponse);
    
    
    String imageUrl = getUrlFromJson(jsonResponse);
      
    //String imageUrl ="http://corporate.hibu.com/~/media/Images/H/Hibu-V2/Image-Library/preview-image/hibu0153.jpg";
    // image not initialised so load it
    initImage(imageUrl);

  }
  
  String httpGet(String urlStr) {

    try {
      URL url = new URL(urlStr);
      HttpURLConnection conn =
          (HttpURLConnection) url.openConnection();
    
        if (conn.getResponseCode() != 200) {
        System.out.println(conn.getResponseCode());;
        throw new IOException(conn.getResponseMessage());
        }
    
      // Buffer the result into a string
      BufferedReader rd = new BufferedReader(
          new InputStreamReader(conn.getInputStream()));
      StringBuilder sb = new StringBuilder();
      String line;
      while ((line = rd.readLine()) != null) {
        sb.append(line);
      }
      rd.close();
    
      conn.disconnect();
      return sb.toString();
    } catch (IOException e) {
      System.out.println(e.getMessage());
    }
    return null;
  }

  String getUrlFromJson(String jsonString) {
    
    JsonParser parser = new JsonParser();
    JsonElement jsonElement = parser.parse(jsonString);
    JsonObject jsonObject = jsonElement.getAsJsonObject();
    
    JsonElement imgElement = jsonObject.get("img");
    
    return imgElement.getAsString();
    
  }
  
  void initImage(String imageUrl) {
    
     // load image
     this.objToLoad.advertImage = loadImage(imageUrl);  // Load the image into the program  
     // calculate drawing dimensions
     //  int prefWidth=400;
     // calculate ratio
     this.objToLoad.aspectRatio = ((float)this.objToLoad.prefWidth / (float)this.objToLoad.advertImage.width);
     
     this.objToLoad.drawWidth = (int)(this.objToLoad.aspectRatio * (float)this.objToLoad.advertImage.width);
     this.objToLoad.drawHeight = (int)(this.objToLoad.aspectRatio * (float)this.objToLoad.advertImage.height);
     
     System.out.println("width:"+this.objToLoad.drawWidth);
     System.out.println("height:"+this.objToLoad.drawHeight);
     
     this.objToLoad.loading=false;
     
  }

  
}
