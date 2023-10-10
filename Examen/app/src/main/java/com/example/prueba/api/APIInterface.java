package com.example.prueba.api;

import com.example.prueba.dto.Product;
import com.example.prueba.dto.ProductList;
import retrofit2.Call;
import retrofit2.http.*;

public interface APIInterface {

    @GET("products")
    Call<ProductList> findAll();

    @GET("products/{id}")
    Call<Product> find(@Path("id") int id);
}
