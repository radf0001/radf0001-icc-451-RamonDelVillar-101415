package com.example.prueba.data;

import android.app.Application;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import com.example.prueba.dto.Product;
import org.jetbrains.annotations.NotNull;

import java.util.List;

public class ProductViewModel extends AndroidViewModel {

    private ProductRepository mRepository;
    private MutableLiveData<List<Product>> productsLiveData;

    public ProductViewModel(@NotNull Application application) {
        super(application);
        mRepository = new ProductRepository(application);
        productsLiveData = mRepository.getProductsLiveData();
    }

    public MutableLiveData<List<Product>> getProductsLiveData() { return productsLiveData; }
    public Product getProduct(int id) { return mRepository.getProduct(id); }
}
