package com.example.prueba.dto;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Product {

    @SerializedName("id")
    public Integer id;
    @SerializedName("title")
    public String title;
    @SerializedName("description")
    public String description;
    @SerializedName("price")
    public String price;
    @SerializedName("discountPercentage")
    public String discountPercentage;
    @SerializedName("rating")
    public String rating;
    @SerializedName("stock")
    public String stock;
    @SerializedName("brand")
    public String brand;
    @SerializedName("category")
    public String category;
    @SerializedName("thumbnail")
    public String thumbnail;
    @SerializedName("images")
    public List<String> images;

    public Product(Integer id, String title, String description, String price, String discountPercentage, String rating, String stock, String brand, String category, String thumbnail, List<String> images) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.discountPercentage = discountPercentage;
        this.rating = rating;
        this.stock = stock;
        this.brand = brand;
        this.category = category;
        this.thumbnail = thumbnail;
        this.images = images;
    }

    public Integer getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getPrice() {
        return price;
    }

    public String getDiscountPercentage() {
        return discountPercentage;
    }

    public String getRating() {
        return rating;
    }

    public String getStock() {
        return stock;
    }

    public String getBrand() {
        return brand;
    }

    public String getCategory() {
        return category;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public List<String> getImages() {
        return images;
    }
}
