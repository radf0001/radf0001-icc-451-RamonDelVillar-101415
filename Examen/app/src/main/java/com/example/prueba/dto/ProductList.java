package com.example.prueba.dto;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ProductList implements Serializable {
    @SerializedName("products")
    public List<Product> products = new ArrayList<>();
    @SerializedName("total")
    public Integer total;
    @SerializedName("skip")
    public Integer skip;
    @SerializedName("limit")
    public Integer limit;

    public ProductList(List<Product> products, Integer total, Integer skip, Integer limit) {
        this.products = products;
        this.total = total;
        this.skip = skip;
        this.limit = limit;
    }

    public List<Product> getProducts() {
        return products;
    }

    public Integer getTotal() {
        return total;
    }

    public Integer getSkip() {
        return skip;
    }

    public Integer getLimit() {
        return limit;
    }
}
