package com.example.remindery;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import java.util.ArrayList;

public class SqlliteHelperClass extends SQLiteOpenHelper {

    private static final String databaseName = "reminder";
    private static final int databaseVersion = 2;

    static final String tableName = "reminders";

    static final String columnId = "id";
    static final String columnTitle = "title";
    static final String columnTime = "time";
    static final String columnDescription = "description";
    static final String columnIsDone = "isDone";
    static final String columnRepeat = "repeat";






    public SqlliteHelperClass(@Nullable Context context) {
        super(context,  databaseName, null, databaseVersion);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {

        String query = "CREATE TABLE " + tableName+ " ( " + columnId+ " INTEGER PRIMARY KEY, " + columnTitle + " TEXT NOT NULL, "+ columnTime +
                " TEXT NOT NULL, "+ columnDescription +" TEXT, " + columnIsDone + " INTEGER )";
        sqLiteDatabase.execSQL(query);

    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {
        sqLiteDatabase.execSQL("DROP TABLE IF EXISTS " + tableName);
        onCreate(sqLiteDatabase);
    }

    public void addReminder(ReminderModel reminder){
        ContentValues values = new ContentValues();
        values.put(columnTitle , reminder.getTitle());
        values.put(columnDescription, reminder.getDescription());
        values.put(columnTime, reminder.getTime());
        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(tableName, null, values);
    }

    public ArrayList<ReminderModel> getReminders(){
        ArrayList<ReminderModel> results = new ArrayList<>();
        String sql = "select * from " + tableName;
        SQLiteDatabase db = this.getReadableDatabase();
       Cursor cursor = db.rawQuery(sql,null);
        if(cursor.moveToFirst()){
            do{
                int id = Integer.parseInt(cursor.getString(0));
                String title = cursor.getString(1);
                String desc = cursor.getString(2);
                String time = cursor.getString(3);
                results.add(new ReminderModel(id, title, desc, time));
            }while (cursor.moveToNext());
        }
        cursor.close();
        return results;
    }

}
