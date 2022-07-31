class BasicUtil {
  static String getNameInitials(String name) {
    String initials = "AB";
    List<String> nameparts = name.split(" ");
    initials = (nameparts.length > 1)
        ? (nameparts[0].isNotEmpty ? nameparts[0][0].toUpperCase() : "") +
            (nameparts[1].isNotEmpty ? nameparts[1][0].toUpperCase() : "")
        : (nameparts[0].isNotEmpty ? nameparts[0][0].toUpperCase() : "");
    return initials;
  }
}
