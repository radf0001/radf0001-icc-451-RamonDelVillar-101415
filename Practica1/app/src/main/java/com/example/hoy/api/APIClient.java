package com.example.hoy.api;
import android.util.Log;
import com.google.gson.*;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Converter;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import java.lang.reflect.Type;
import java.util.concurrent.TimeUnit;

public final class APIClient {


    private APIClient() {
    }

    public static Retrofit getClient() {
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        OkHttpClient client = new OkHttpClient.Builder()
                .readTimeout(60, TimeUnit.SECONDS)
                .connectTimeout(60, TimeUnit.SECONDS)
                .addInterceptor(interceptor).build();

        return new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create())
//                .addConverterFactory(createGsonConverter(type, typeAdapter))
                .baseUrl("https://reqres.in/api/")
                // .client(client)
                .build();

    }

    private static Converter.Factory createGsonConverter(Type type, Object typeAdapter) {
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(type, typeAdapter);
        Gson gson = gsonBuilder.create();

        return GsonConverterFactory.create(gson);
    }

//    public static class GetUserDeserializer implements JsonDeserializer<User> {
//        @Override
//        public User deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
//            final JsonObject jsonObject = json.getAsJsonObject().getAsJsonObject("data");
//
//            Log.w("jsonObject", jsonObject.toString());
//
//            final int id = jsonObject.get("id").getAsInt();
//            final String email = jsonObject.get("email").getAsString();
//            final String firstName = jsonObject.get("first_name").getAsString();
//            final String lastName = jsonObject.get("last_name").getAsString();
//            final String avatar = jsonObject.get("avatar").getAsString();
//
//            return new User(id, email, firstName, lastName, avatar);
//        }
//    }
//
//    public static class GetUserListDeserializer implements JsonDeserializer<List<User>> {
//
//        @Override
//        public List<User> deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
//            List<User> users = new ArrayList<>();
//
//            final JsonArray jsonArray = json.getAsJsonObject().getAsJsonArray("data");
//
//            Log.w("jsonArray", jsonArray.toString());
//
//            jsonArray.forEach(element -> {
//                final int id = element.getAsJsonObject().get("id").getAsInt();
//                final String email = element.getAsJsonObject().get("email").getAsString();
//                final String firstName = element.getAsJsonObject().get("first_name").getAsString();
//                final String lastName = element.getAsJsonObject().get("last_name").getAsString();
//                final String avatar = element.getAsJsonObject().get("avatar").getAsString();
//
//                users.add(new User(id, email, firstName, lastName, avatar));
//            });
//
//
//            return users;
//        }
//    }
}
