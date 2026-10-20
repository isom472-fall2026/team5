class InternshipSiteSelection:
    def __init__(self):
     self.sites = [
            {"name": "Tech Corp", "sector": "Private", "major": "Computer Science", "positions": ["Software Engineer", "Data Analyst"]},
            {"name": "Gov Agency", "sector": "Government", "major": "Information Systems", "positions": ["IT Support", "Systems Analyst"]},
            {"name": "Public Health", "sector": "Public", "major": "Health Informatics", "positions": ["Database Administrator"]}
        ]

    def filter_sites(self, sector=None):
        if sector:
            return [site for site in self.sites if site['sector'] == sector]
        return self.sites

    def match_student_major(self, student_major, sector=None):
        available_sites = self.filter_sites(sector)
        return [site for site in available_sites if site['major'] == student_major]


selection_system = InternshipSiteSelection()
is_sites = selection_system.match_student_major("Information Systems")
print(f"Information Systems: {is_sites}")