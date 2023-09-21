package com.example.myfirstapp;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.*;

import java.text.DateFormat;
import java.util.Calendar;

public class MainActivity extends AppCompatActivity implements DatePickerDialog.OnDateSetListener {
    public static final String EXTRA_MESSAGE = "com.example.myfirstapp.MESSAGE";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Calendar c = Calendar.getInstance();
        String currentDateString = DateFormat.getDateInstance().format(c.getTime());

        Button buttonFecha = findViewById(R.id.btnFecha);
        buttonFecha.setText(currentDateString);
        buttonFecha.setOnClickListener(view -> {
            DialogFragment datePicker = new DatePickerFragment();
            datePicker.show(getSupportFragmentManager(), "date picker");
        });

        RadioGroup radioGroup = findViewById(R.id.radioGroup);
        radioGroup.setOnCheckedChangeListener((radioGroup1, i) -> {
            CheckBox checkBoxGo;
            CheckBox checkBoxJava;
            CheckBox checkBoxRust;
            CheckBox checkBoxRuby;
            CheckBox checkBoxPython;
            CheckBox checkBoxJS;

            switch (i){
                case R.id.valNo:
                    checkBoxGo = findViewById(R.id.valGo);
                    checkBoxGo.setChecked(false);
                    checkBoxGo.setEnabled(false);

                    checkBoxJava = findViewById(R.id.valJava);
                    checkBoxJava.setChecked(false);
                    checkBoxJava.setEnabled(false);

                    checkBoxRust = findViewById(R.id.valRust);
                    checkBoxRust.setChecked(false);
                    checkBoxRust.setEnabled(false);

                    checkBoxRuby = findViewById(R.id.valRuby);
                    checkBoxRuby.setChecked(false);
                    checkBoxRuby.setEnabled(false);

                    checkBoxPython = findViewById(R.id.valPython);
                    checkBoxPython.setChecked(false);
                    checkBoxPython.setEnabled(false);

                    checkBoxJS = findViewById(R.id.valJS);
                    checkBoxJS.setChecked(false);
                    checkBoxJS.setEnabled(false);
                    break;
                case R.id.valSi:
                    checkBoxGo = findViewById(R.id.valGo);
                    checkBoxGo.setEnabled(true);

                    checkBoxJava = findViewById(R.id.valJava);
                    checkBoxJava.setEnabled(true);

                    checkBoxRust = findViewById(R.id.valRust);
                    checkBoxRust.setEnabled(true);

                    checkBoxRuby = findViewById(R.id.valRuby);
                    checkBoxRuby.setEnabled(true);

                    checkBoxPython = findViewById(R.id.valPython);
                    checkBoxPython.setEnabled(true);

                    checkBoxJS = findViewById(R.id.valJS);
                    checkBoxJS.setEnabled(true);
                    break;
            }
        });
    }

    @Override
    public void onDateSet(DatePicker datePicker, int i, int i1, int i2) {
        Calendar c = Calendar.getInstance();
        c.set(Calendar.YEAR, i);
        c.set(Calendar.MONTH, i1);
        c.set(Calendar.DAY_OF_MONTH, i2);
        String currentDateString = DateFormat.getDateInstance().format(c.getTime());

        Button buttonFecha = findViewById(R.id.btnFecha);
        buttonFecha.setText(currentDateString);
    }

    public void validar(View view){
        TextView textViewNombre = findViewById(R.id.valNombre);
        TextView textViewApellido = findViewById(R.id.valApellido);
        Spinner spinnerGenero = findViewById(R.id.valGenero);
        Button buttonFecha = findViewById(R.id.btnFecha);
        RadioButton rdbtnSi = findViewById(R.id.valSi);
        CheckBox checkBoxGo = findViewById(R.id.valGo);
        CheckBox checkBoxJava = findViewById(R.id.valJava);
        CheckBox checkBoxRust = findViewById(R.id.valRust);
        CheckBox checkBoxRuby = findViewById(R.id.valRuby);
        CheckBox checkBoxPython = findViewById(R.id.valPython);
        CheckBox checkBoxJS = findViewById(R.id.valJS);

        if (textViewNombre.getText().toString().isEmpty()){
            Toast.makeText(MainActivity.this, "Debe digitar un nombre", Toast.LENGTH_SHORT).show();
        } else if(textViewApellido.getText().toString().isEmpty()){
            Toast.makeText(MainActivity.this, "Debe digitar un apellido", Toast.LENGTH_SHORT).show();
        }else if(rdbtnSi.isChecked() && !checkBoxGo.isChecked() && !checkBoxJava.isChecked() && !checkBoxRust.isChecked() &&
                !checkBoxRuby.isChecked() && !checkBoxPython.isChecked() && !checkBoxJS.isChecked()){
            Toast.makeText(MainActivity.this, "Si le gusta programar debe seleccionar al menos un lenguaje.", Toast.LENGTH_SHORT).show();
        }else{
            Intent intent = new Intent(this, DisplayMessageActivity.class);
            String message = "Mi nombre es: " + textViewNombre.getText().toString() + " " + textViewApellido.getText().toString() + ".\n\n";
            message += "Soy " + spinnerGenero.getSelectedItem().toString() + ", y naci en fecha " + buttonFecha.getText().toString() + ".\n\n";
            if(rdbtnSi.isChecked()){
                message += "Me gusta programar. Mis lenguajes favoritos son:";
                if(checkBoxGo.isChecked())
                    message += " Go,";
                if(checkBoxJava.isChecked())
                    message += " Java,";
                if(checkBoxRust.isChecked())
                    message += " Rust,";
                if(checkBoxRuby.isChecked())
                    message += " Ruby,";
                if(checkBoxPython.isChecked())
                    message += " Python,";
                if(checkBoxJS.isChecked())
                    message += " JavaScript";
                message += ".";
            }else{
                message += "No me gusta programar.";
            }
            intent.putExtra(EXTRA_MESSAGE, message);
            startActivity(intent);
        }
    }

    public void limpiar(View view){
        TextView textViewNombre = findViewById(R.id.valNombre);
        textViewNombre.setText("");

        TextView textViewApellido = findViewById(R.id.valApellido);
        textViewApellido.setText("");

        Spinner spinnerGenero = findViewById(R.id.valGenero);
        spinnerGenero.setSelection(0);

        Calendar c1 = Calendar.getInstance();
        String currentDateString1 = DateFormat.getDateInstance().format(c1.getTime());
        Button buttonFecha = findViewById(R.id.btnFecha);
        buttonFecha.setText(currentDateString1);

        RadioButton rdbtnSi = findViewById(R.id.valSi);
        rdbtnSi.setChecked(true);

        RadioButton rdbtnNo = findViewById(R.id.valNo);
        rdbtnNo.setChecked(false);

        CheckBox checkBoxGo = findViewById(R.id.valGo);
        checkBoxGo.setChecked(false);

        CheckBox checkBoxJava = findViewById(R.id.valJava);
        checkBoxJava.setChecked(false);

        CheckBox checkBoxRust = findViewById(R.id.valRust);
        checkBoxRust.setChecked(false);

        CheckBox checkBoxRuby = findViewById(R.id.valRuby);
        checkBoxRuby.setChecked(false);

        CheckBox checkBoxPython = findViewById(R.id.valPython);
        checkBoxPython.setChecked(false);

        CheckBox checkBoxJS = findViewById(R.id.valJS);
        checkBoxJS.setChecked(false);
    }
}