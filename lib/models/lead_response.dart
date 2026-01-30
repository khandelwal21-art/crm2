class LeadsResponse {
  Counts? counts;
  dynamic whatsappMarketing;
  List<dynamic> projects;
  dynamic setting;
  int? count;
  dynamic next;
  dynamic previous;
  List<dynamic> results;

  LeadsResponse({
    this.counts,
    this.whatsappMarketing,
    required this.projects,
    this.setting,
    this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory LeadsResponse.fromJson(Map<String, dynamic> json) {
    return LeadsResponse(
      counts: json['counts'] != null ? Counts.fromJson(json['counts']) : null,
      whatsappMarketing: json['whatsapp_marketing'],
      projects: json['projects'] ?? [],
      setting: json['setting'],
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counts': counts?.toJson(),
      'whatsapp_marketing': whatsappMarketing,
      'projects': projects,
      'setting': setting,
      'count': count,
      'next': next,
      'previous': previous,
      'results': results,
    };
  }
}

class Counts {
  int? totalLeads;
  int? totalInterestedLeads;
  int? totalNotInterestedLeads;
  int? totalOtherLocationLeads;
  int? totalNotPickedLeads;
  int? totalVisitsLeads;

  Counts({
    this.totalLeads,
    this.totalInterestedLeads,
    this.totalNotInterestedLeads,
    this.totalOtherLocationLeads,
    this.totalNotPickedLeads,
    this.totalVisitsLeads,
  });

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      totalLeads: json['total_leads'],
      totalInterestedLeads: json['total_interested_leads'],
      totalNotInterestedLeads: json['total_not_interested_leads'],
      totalOtherLocationLeads: json['total_other_location_leads'],
      totalNotPickedLeads: json['total_not_picked_leads'],
      totalVisitsLeads: json['total_visits_leads'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_leads': totalLeads,
      'total_interested_leads': totalInterestedLeads,
      'total_not_interested_leads': totalNotInterestedLeads,
      'total_other_location_leads': totalOtherLocationLeads,
      'total_not_picked_leads': totalNotPickedLeads,
      'total_visits_leads': totalVisitsLeads,
    };
  }
}
