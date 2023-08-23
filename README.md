# TransAll

Welcome to the airtime and money Transfer App! TransAll is a user-friendly and feature-rich mobile application designed to simplify the process of transferring mobile credit and managing transactions effectively. With TransAll, you can conveniently transfer credit to family and friends, ensuring they stay connected when they need it the most.

## Features

- **Credit Transfer:** Seamlessly transfer mobile credit to any recipient within seconds, providing them with the means to make calls, send messages, or use mobile data.

- **Transaction History:** Keep track of your credit transfers and view a detailed transaction history, allowing you to monitor your usage and stay informed about your past transfers.

- **Secure and Reliable:** Rest assured that your transactions are conducted in a secure environment, ensuring the confidentiality of your personal and financial information.

- **User-Friendly Interface:** Enjoy a clean and intuitive interface that makes credit transfers and transaction management a breeze, even for users with minimal technical knowledge.

- **Bank-Grade Security:** Our application employs the latest encryption and security protocols to safeguard your data and transactions.

![TransAll Image](/app_customers/assets/icons/transall.png)

## Getting Started

### Prerequisites

Install the [Flutter SDK](https://flutter.dev/docs/get-started/install)
(version 3.10.6).

### Clone the repository

1. **Installation:** Clone this repository to your local machine using:

   ```sh
   git clone https://github.com/karibu-cap/trans_all_client.git
   ```

### Build and run

#### Android and iOS

Check that the device is running.

```
flutter devices
```

Run the app:

```
flutter run
```

#### Web (Chrome)

Build and run on chrome:

```
flutter run -d chrome
```

Environments:

- dev
- staging
- prod

### DEV environment

```
flutter run --dart-define=TRANSTU_APP_ENVIRONMENT=dev --dart-define=TRANSTU_APP_NAME=TransTu.dev
```

### staging environment

```
flutter run --dart-define=TRANSTU_APP_ENVIRONMENT=staging --dart-define=TRANSTU_APP_NAME=TransAll.staging
```

## Goldens

We use screenshot diffing to validate and review changes that affect the UI. To generate or update these screenshots (goldens),
navigate to the flutter project subdirectory, and run:

```
flutter test --update-goldens --tags=golden
```
