package com.example.prueba;

import android.util.Log;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.example.prueba.api.APIClient;
import com.example.prueba.api.APIInterface;
import com.example.prueba.data.ProductViewModel;
import com.example.prueba.databinding.ActivityMainBinding;
import com.example.prueba.dto.ProductList;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

public class MainActivity extends AppCompatActivity {

    private ProductViewModel mProductViewModel;
    ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        RecyclerView recyclerView = binding.productsRecyclerView;
        recyclerView.setLayoutManager(new LinearLayoutManager(getApplicationContext()));
        ProductListAdapter adapter = new ProductListAdapter(new ProductListAdapter.ProductDiff());
        recyclerView.setAdapter(adapter);

//        APIInterface api = APIClient.getClient().create(APIInterface.class);
//
//        api.findAll().enqueue(new Callback<ProductList>() {
//            @Override
//            public void onResponse(Call<ProductList> call, Response<ProductList> response) {
//                Log.w("onResponse", response.body().toString());
//            }
//
//            @Override
//            public void onFailure(Call<ProductList> call, Throwable t) {
//                Log.w("onFailure", t.getMessage());
//                call.cancel();
//            }
//        });

        // Get a new or existing ViewModel from the ViewModelProvider.
        mProductViewModel = new ViewModelProvider(this).get(ProductViewModel.class);

        mProductViewModel.getProductsLiveData().observe(this, products -> {
            adapter.submitList(products);
        });
    }
}