package com.example.remindery;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import androidx.core.app.NotificationCompat;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class HelperMethods {

    public static String CHANNEL_ID = "3597";

    public static String formatDate(int year, int month, int day){
        String months[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
                "Sep", "Oct", "Nov", "Dec" };


        String res = day + " , "+ months[month]+ " " + year;
        return  res;
    }
    public static String getISODateTime(Date date) {

        SimpleDateFormat dateFormat = new SimpleDateFormat(

                "yyyy-MM-dd HH:mm:ss", Locale.getDefault());

        return dateFormat.format(date);

    }
    public static String formatTime(int hourOfDay, int minute){
        int hour = hourOfDay;
        int minutes = minute;
        String timeSet = "";
        if (hour > 12) {
            hour -= 12;
            timeSet = "PM";
        } else if (hour == 0) {
            hour += 12;
            timeSet = "AM";
        } else if (hour == 12){
            timeSet = "PM";
        }else{
            timeSet = "AM";
        }

        String min = "";
        if (minutes < 10)
            min = "0" + minutes ;
        else
            min = String.valueOf(minutes);

        // Append in a StringBuilder
        String aTime = new StringBuilder().append(hour).append(':')
                .append(min ).append(" ").append(timeSet).toString();
        return  aTime;
    }

    public static void createNotification(Context context, String title, String Description, String time, String Id){

        Intent intent = new Intent( context, MainActivity.class);

        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_calendar_today_24px)
                .setContentTitle("You Have a Imp Reminder")
                .setContentText(title)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(Description))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                // Set the intent that will fire when the user taps the notification
                .setContentIntent(pendingIntent)
                .setAutoCancel(true);

        Notification notification = builder.build();
        Intent notificationIntent = new Intent(context, NotificationPublisher.class ) ;
        notificationIntent.putExtra(NotificationPublisher. NOTIFICATION_ID , Id) ;
        notificationIntent.putExtra(NotificationPublisher. NOTIFICATION , notification) ;
        PendingIntent pendingIntent1 = PendingIntent.getBroadcast ( context, 0 , notificationIntent , PendingIntent. FLAG_UPDATE_CURRENT ) ;
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context. ALARM_SERVICE ) ;
        assert alarmManager != null;
        alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP ,  , pendingIntent) ;

    }
}
