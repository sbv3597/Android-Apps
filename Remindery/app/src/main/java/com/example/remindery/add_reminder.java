package com.example.remindery;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.os.Bundle;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.text.format.DateFormat;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TimePicker;

import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Date;

public class add_reminder extends AppCompatActivity implements DatePickerDialog.OnDateSetListener, TimePickerDialog.OnTimeSetListener {

    private TextView dateView,timeView;
    private EditText titleEdit, descEdit;
    int day, month, year, hour, minute;
    Calendar reminderDateTime;
    Calendar finalDateTime;
    SqlliteHelperClass database;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_reminder);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        titleEdit = findViewById(R.id.edit_title);
        descEdit = findViewById(R.id.edit_description);
        findViewById(R.id.add_reminders).setOnTouchListener(
                new View.OnTouchListener() {
                    @Override
                    public boolean onTouch(View view, MotionEvent motionEvent) {
                        InputMethodManager inputMethodManager =
                                (InputMethodManager) add_reminder.this.getSystemService(
                                        add_reminder.this.INPUT_METHOD_SERVICE);
                        if(add_reminder.this.getCurrentFocus() != null){
                        inputMethodManager.hideSoftInputFromWindow(
                                add_reminder.this.getCurrentFocus().getWindowToken(), 0);
                            add_reminder.this.getCurrentFocus().clearFocus();
                        }
                        return true;
                    }
                }
        );
        database = new SqlliteHelperClass(this);
        reminderDateTime = Calendar.getInstance();
        finalDateTime = reminderDateTime;

        dateView = findViewById(R.id.date_text);

        timeView = findViewById(R.id.time_text);
        year = reminderDateTime.get(Calendar.YEAR);
        month = reminderDateTime.get(Calendar.MONTH);
        day = reminderDateTime.get(Calendar.DAY_OF_MONTH);
        hour = reminderDateTime.get(Calendar.HOUR);
        minute = reminderDateTime.get(Calendar.MINUTE);
        dateView.setText(HelperMethods.formatDate(year,month,day));
        timeView.setText(HelperMethods.formatTime(hour,minute));
       // titleEdit = findViewById(R.id.)

        dateView.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        DatePickerDialog datePickerDialog = new DatePickerDialog(add_reminder.this, add_reminder.this,year, month,day);
                        datePickerDialog.show();
                    }
                }
        );
        timeView.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        TimePickerDialog timePickerDialog = new TimePickerDialog(add_reminder.this, add_reminder.this, hour, minute, DateFormat.is24HourFormat(add_reminder.this));
                        timePickerDialog.show();
                    }
                }
        );


    }

    @Override
    public void onDateSet(DatePicker datePicker, int i, int i1, int i2) {
        finalDateTime.set(i,i1,i2);
        dateView.setText(HelperMethods.formatDate(i,i1,i2));

    }

    @Override
    public void onTimeSet(TimePicker timePicker, int i, int i1) {
        finalDateTime.set(Calendar.HOUR, i);
        finalDateTime.set(Calendar.MINUTE, i1);
        timeView.setText(HelperMethods.formatTime(i,i1));
    }

    public void saveReminder(View view){
        if(finalDateTime != null && titleEdit.getText() != null){
            ReminderModel model = new ReminderModel(titleEdit.getText().toString(), HelperMethods.getISODateTime(finalDateTime.getTime()), descEdit.getText().toString());
            database.addReminder(model);
            finish();
        }

    }

}
