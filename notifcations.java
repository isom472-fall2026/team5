import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NotificationSystem {
    private List<Map<String, String>> notifications;

    public NotificationSystem() {
        notifications = new ArrayList<>();
        
        Map<String, String> note1 = new HashMap<>();
        note1.put("title", "Internship Seminar");
        note1.put("date", "2026-10-25");
        note1.put("time", "10:00 AM");
        note1.put("location", "Auditorium A");
        notifications.add(note1);

        Map<String, String> note2 = new HashMap<>();
        note2.put("title", "Meet the Employers");
        note2.put("date", "2026-11-01");
        note2.put("time", "02:00 PM");
        note2.put("location", "Main Hall");
        notifications.add(note2);
    }

    public List<Map<String, String>> retrieveNotifications(String studentId) {
        if (studentId == null || !studentId.startsWith("S")) {
            throw new IllegalArgumentException("Invalid Student ID. Cannot retrieve notifications.");
        }

        List<Map<String, String>> validatedNotifications = new ArrayList<>();
        for (Map<String, String> note : notifications) {
            if (!isValidAnnouncement(note)) {
                String title = note.getOrDefault("title", "Unknown");
                throw new IllegalArgumentException("Missing or incorrect fields in announcement: " + title);
            }
            validatedNotifications.add(note);
        }

        return validatedNotifications;
    }

    private boolean isValidAnnouncement(Map<String, String> announcement) {
        String[] requiredFields = {"title", "date", "time", "location"};
        for (String field : requiredFields) {
            if (!announcement.containsKey(field) || announcement.get(field) == null || announcement.get(field).isEmpty()) {
                return false;
            }
        }
        return true;
    }
}
