# Tourguide

 https://jumperche.shinyapps.io/tour/




# TourGuideConnect - A Shiny Mobile Application

TourGuideConnect is a progressive web application (PWA) built with Shiny and `shinyMobile`. It connects tourists with local guides, enabling seamless booking and management of guided tours. With features like dynamic profile management, appointment requests, and real-time search, this app is designed for efficient and user-friendly interactions.

---

## Features

- **User Roles**: Separate profiles and functionalities for `Tourists` and `Guides`.
- **Search and Connect**: Tourists can search for guides based on expertise and request appointments.
- **Dynamic UI**: Role-based UI updates with `shinyMobile` for a modern and responsive design.
- **Profile Management**: Edit personal and professional details, including location, expertise, and pricing.
- **Appointment Handling**: Request, accept, or reject appointments dynamically.
- **Dark Mode**: Toggle between light and dark themes for better accessibility.
- **Progressive Web App (PWA)**: Installable on devices with offline capabilities.

---

## Prerequisites

Before running the app, ensure you have the following installed:

- **R** (version ≥ 4.0)
- **RStudio** (optional)
- Required R packages:
  ```r
  install.packages(c(
    "shiny", "shinyMobile", "shinyWidgets", "dplyr", "DT", "shinyjs", "digest"
  ))
  ```

- Ensure the `jump2pwa.R` script is present in the working directory.

---

## Getting Started

### 1. **Clone the Repository**
```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. **Prepare Data**
Ensure the following `.rds` files are available in the working directory:

- `users.rds`: Stores information about registered tourists.
- `guides.rds`: Stores information about registered guides.
- `credentials.rds`: Stores user credentials (email and hashed passwords).
- `pending_requests.rds`: Stores pending appointment requests.

### 3. **Run the App**
Open the `app.R` file in RStudio or your preferred IDE, and click "Run App". Alternatively, use the command:
```r
shiny::runApp("path/to/app.R")
```

### 4. **Use the Application**
- **Tourists**:
  - Search for guides by expertise or location.
  - Request appointments and view status updates.
- **Guides**:
  - View and manage appointment requests.
  - Edit professional details, including pricing and expertise.

---

## Folder Structure

```plaintext
.
├── app.R                  # Main application file
├── jump2pwa.R             # Helper script for PWA setup
├── users.rds              # Data for tourist profiles
├── guides.rds             # Data for guide profiles
├── credentials.rds        # User credentials (hashed)
├── pending_requests.rds   # Pending appointment requests
├── README.md              # This README file
└── www/                   # Directory for PWA assets
    ├── manifest.json      # PWA manifest file
    ├── service-worker.js  # Service worker script
    ├── icon.png           # PWA icon
    └── icon_maskable.png  # Maskable PWA icon
```

---

## Application Highlights

### **User Roles**
- **Tourist**:
  - Search and connect with guides.
  - Request and view appointment status.
- **Guide**:
  - Manage appointment requests.
  - Customize profile with expertise, pricing, and availability.

### **Dark Mode**
- Toggle between light and dark themes for better visibility and accessibility.

### **Progressive Web App (PWA)**
- Installable on mobile and desktop devices.
- Offline functionality for seamless access.

### **Dynamic Profile Management**
- Edit and update profiles dynamically based on user roles.
- Guides can specify pricing, expertise, and preferred locations.

### **Appointment Requests**
- Tourists can send appointment requests with date and time preferences.
- Guides can accept or reject requests in real-time.

---

## Future Enhancements

- **Rating System**: Allow tourists to rate guides.
- **Multi-language Support**: Provide multilingual interface options.
- **Push Notifications**: Notify users of updates or new appointment requests.
- **Integration with Maps**: Show guide locations on a map.

---

## Contribution

Contributions are welcome! Submit issues or pull requests with detailed descriptions. Ensure changes are thoroughly tested.

---

## License

This project is licensed under the BSD 3-Clause License. See the `LICENSE` file for more details.

---

Experience seamless connection between tourists and guides with **TourGuideConnect**! 🚀
