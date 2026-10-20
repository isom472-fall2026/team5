from datetime import datetime

class NotificationSystem:
    def _init_(self):
        self.notifications = [
            {"title": "Internship Seminar", "date": "2026-10-25", "time": "10:00 AM", "location": "Auditorium A"},
            {"title": "Meet the Employers", "date": "2026-11-01", "time": "02:00 PM", "location": "Main Hall"}
        ]

    def retrieve_notifications(self, student_id):
        if not student_id or not student_id.startswith('S'):
            raise ValueError("Invalid Student ID. Cannot retrieve notifications.")

        validated_notifications = []
        for note in self.notifications:
            if not self._is_valid_announcement(note):
                 raise ValueError(f"Missing or incorrect fields in announcement: {note.get('title', 'Unknown')}")
            validated_notifications.append(note)

        return validated_notifications

    def _is_valid_announcement(self, announcement):
        required_fields = ["title", "date", "time", "location"]
        for field in required_fields:
            if field not in announcement or not announcement[field]:
                return False
        return True