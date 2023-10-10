package com.example.prueba.data;

import android.app.Application;
import android.util.Log;
import androidx.lifecycle.MutableLiveData;
import com.example.prueba.api.APIClient;
import com.example.prueba.api.APIInterface;
import com.example.prueba.dto.Product;
import com.example.prueba.dto.ProductList;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.util.List;

public class ProductRepository {

    private APIInterface api;
    private MutableLiveData<List<Product>> productsLiveData = new MutableLiveData<>();

    ProductRepository(Application application){
        api = APIClient.getClient().create(APIInterface.class);
        api.findAll().enqueue(new Callback<ProductList>() {
            @Override
            public void onResponse(Call<ProductList> call, Response<ProductList> response) {
                Log.w("onResponse", "OK");
                productsLiveData.setValue(response.body().getProducts());
            }

            @Override
            public void onFailure(Call<ProductList> call, Throwable t) {
                Log.w("onFailure", t.getMessage());
                call.cancel();
            }
        });
    }

    public MutableLiveData<List<Product>> getProductsLiveData(){
        return productsLiveData;
    }

    public Product getProduct(int id){
        final Product[] product1 = new Product[1];
        api.find(id).enqueue(new Callback<Product>() {
            @Override
            public void onResponse(Call<Product> call, Response<Product> response) {
                product1[0] =  response.body();
            }

            @Override
            public void onFailure(Call<Product> call, Throwable t) {
                Log.w("onFailure", t.getMessage());
                call.cancel();
            }
        });
        return product1[0];
    }
}
