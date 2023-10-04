package com.example.tarea4.data;

import android.content.Context;
import android.os.AsyncTask;
import androidx.annotation.NonNull;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.sqlite.db.SupportSQLiteDatabase;
import com.example.tarea4.entities.Tarea;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Database(entities = {Tarea.class}, version = 1, exportSchema = false)
public abstract class TareaRoomDatabase extends RoomDatabase {

    public abstract TareaDao tareaDao();

    private static volatile TareaRoomDatabase INSTANCE;
    private static final int NUMBER_OF_THREADS = 4;
    static final ExecutorService databaseWriteExecutor =
            Executors.newFixedThreadPool(NUMBER_OF_THREADS);

    static TareaRoomDatabase getDatabase(final Context context) {
        if (INSTANCE == null) {
            synchronized (TareaRoomDatabase.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                                    TareaRoomDatabase.class, "tarea_database")
                            .addCallback(sRoomDatabaseCallback)
                            .build();
                }
            }
        }
        return INSTANCE;
    }

    private static RoomDatabase.Callback sRoomDatabaseCallback =new RoomDatabase.Callback() {
        @Override
        public void onCreate(@NonNull SupportSQLiteDatabase db) {
            super.onCreate(db);

            databaseWriteExecutor.execute(() -> {
                // Populate the database in the background.
                // If you want to start with more words, just add them.
                TareaDao dao = INSTANCE.tareaDao();
                dao.deleteAll();

                Tarea tarea = new Tarea(false, "#008000", "Tarea 1");
                dao.insert(tarea);
                tarea = new Tarea(true, "#000080", "Tarea 2");
                dao.insert(tarea);
            });
        }
    };
}
