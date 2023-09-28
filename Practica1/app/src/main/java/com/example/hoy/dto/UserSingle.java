package com.example.hoy.dto;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class UserSingle implements Serializable {

    @SerializedName("data")
    public User data;

    public UserSingle(User data) {
        this.data = data;
    }

    public User getData() {
        return data;
    }
}
