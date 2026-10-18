
from datetime import datetime


class InternshipLog:

    def __init__(self, student_id, work_date):
        self.student_id = student_id
        self.work_date = work_date
        self.check_in_time = None
        self.check_out_time = None
        self.total_hours = 0.0
        self.status = "Pending"

    def record_times(self, check_in_str, check_out_str):
        try:
            check_in = datetime.strptime(
                check_in_str, "%H:%M"
            ).time()

            check_out = datetime.strptime(
                check_out_str, "%H:%M"
            ).time()

            if check_out <= check_in:
                raise ValueError(
                    "Check-out time must be after check-in time."
                )

            self.check_in_time = check_in
            self.check_out_time = check_out
            self._calculate_total_hours()

            return True, "Times recorded successfully."

        except ValueError as e:
            return False, f"Error: {str(e)}"

    def _calculate_total_hours(self):
        in_delta = (
            self.check_in_time.hour
            + self.check_in_time.minute / 60.0
        )

        out_delta = (
            self.check_out_time.hour
            + self.check_out_time.minute / 60.0
        )

        self.total_hours = out_delta - in_delta

    def set_status(self, supervisor_decision):
        if supervisor_decision in ["Approved", "Rejected"]:
            self.status = supervisor_decision
            return True, f"Log marked as {self.status}"

        return False, "Invalid decision."


def submit_log(student_id, work_date, check_in_str, check_out_str):

    # Check that all fields are provided
    if not all([
        student_id,
        work_date,
        check_in_str,
        check_out_str
    ]):
        print("Error: All columns are required.")
        return False, None

    # Validate the date format
    try:
        datetime.strptime(work_date, "%Y-%m-%d")
    except ValueError:
        print("Error: Invalid date. Use YYYY-MM-DD.")
        return False, None

    # Create the internship log
    log = InternshipLog(student_id, work_date)

    # Record check-in and check-out times
    success, message = log.record_times(
        check_in_str, check_out_str
    )

    if not success:
        print(f"Submission failed: {message}")
        return False, None

    print(
        f"Log for {log.work_date} submitted "
        f"for Student {log.student_id}."
    )

    print(
        f"Total Hours: {log.total_hours:.2f}. "
        f"Status: {log.status}"
    )

    return True, log


# Example usage
success, log_entry = submit_log(
    "S12345",
    "2026-10-18",
    "09:00",
    "17:30"
)

if success:
    status_success, message = log_entry.set_status("Approved")

    if status_success:
        print(message)
        print(f"Updated Status: {log_entry.status}")
    else:
        print(message)