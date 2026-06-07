# Tourism App Project Knowledge

## Project Vision

This project is a gamified tourism application. A tourist creates an account, uploads or scans passport photos, waits for passport verification, then gains access to the app after the passport is accepted as valid.

After verification, the tourist can claim entry points. The points system changes based on behavior in the country:

- Points increase when the tourist respects the country's laws and public rules.
- Points decrease when the tourist behaves badly or gets reported.
- Sanctions may apply when reports or rule violations are confirmed.

Examples of good behavior:

- Does not throw garbage in the streets.
- Respects road signs.
- Respects monuments and famous places.
- Respects opening hours.
- Respects entrance and leaving times.

The app should also include an ML-powered tourism map. The map should help tourists choose where to go by showing registered tourist places and predicting crowd levels for a selected time. It should support reservations, public transportation stations, ticket buying, and payment methods.

## Current Project Location

Main Flutter app:

```text
tourism_app_flutter_framework/home/ubuntu/tourism_app
```

Important documents:

```text
tourism_app_flutter_framework/home/ubuntu/tourism_app_structure.md
tourism_app_flutter_framework/home/ubuntu/TODO.txt
tourism_app_flutter_framework/home/ubuntu/tourism_app/PROJECT_KNOWLEDGE.md
```

## Technology Stack

Current dependencies include:

- Flutter
- GetX for routing, state management, and bindings
- Firebase Core
- Firebase Auth
- Cloud Firestore
- Firebase Realtime Database dependency, though not meaningfully used yet
- Firebase Storage
- Shared Preferences
- Dio and HTTP
- Google Maps Flutter
- Camera
- Image Picker
- Permission Handler
- Geolocator
- Google ML Kit Text Recognition

The project is currently a Flutter mobile/web app with Firebase as the main backend.

## Current Architecture

The app follows a feature-folder style with GetX controllers, screens, and bindings.

Main folders:

```text
lib/
  main.dart
  app/
    bindings/
    middleware/
    routes/
    themes/
  core/
    network/
    services/
  data/
    datasources/
  features/
    auth/
    credits/
    home/
    map/
    passport/
    profile/
```

The architecture document proposes a fuller structure with models, repositories, remote datasources, local datasources, and AI modules, but much of that is not implemented yet.

Missing or mostly placeholder architectural layers:

- `data/models`
- `data/repositories`
- `data/datasources/remote`
- `core/ai`
- Strong domain/business logic layer
- Real API implementation layer
- Real ML integration layer

## Routing

Routes are defined in:

```text
lib/app/routes/app_routes.dart
lib/app/routes/app_pages.dart
```

Current route constants:

- `/login`
- `/signup`
- `/home`
- `/map`
- `/passport/scan`
- `/passport/manage`
- `/credits/history`
- `/credits/redemption`
- `/profile`
- `/signup-stepper`
- `/under-verification`
- `/rejected`
- `/forgot-password`

The app uses GetX `GetMaterialApp` and `GetPage` route definitions.

## Implemented Auth And Verification Gate

The app now uses the main `MyApp` widget in `main.dart`, so `InitialBinding` is active.

Current startup behavior:

- If no Firebase Auth user exists, initial route is login.
- If a Firebase Auth user exists, initial route is home.
- Home then checks the user's account verification status and redirects if needed.

Account status values currently used:

- `pending_passport`
- `under_verification`
- `verified`
- `rejected`

Current status behavior:

- `verified`: user can access Home and main app features.
- `under_verification`: user is redirected to the waiting screen.
- `rejected`: user is redirected to the rejected screen.
- `pending_passport` or missing status: user is redirected to passport verification/upload.

Important files:

```text
lib/main.dart
lib/app/middleware/auth_middleware.dart
lib/features/auth/presentation/controllers/login_controller.dart
lib/features/home/presentation/controllers/home_controller.dart
lib/features/passport/presentation/controllers/passport_manage_controller.dart
lib/features/passport/presentation/screens/passport_manage_screen.dart
```

## Auth Feature

Implemented screens:

- Login
- Signup
- Signup stepper
- Forgot password
- Under verification
- Rejected

Implemented controllers:

- `LoginController`
- `SignupController`
- `SignupStepperController`
- `ForgotPasswordController`

Current login behavior:

- Uses Firebase Auth email/password login.
- Gets Firebase ID token.
- Saves token locally with Shared Preferences.
- Reads account status from Firestore.
- Redirects user based on status.

Current signup behavior:

- Creates Firebase Auth user.
- Creates Firestore account document under `accounts/{uid}`.
- Sets user status to `pending_passport`.
- Initializes credits to `150` in the regular signup controller.
- Redirects to passport management/upload screen.

Current signup stepper behavior:

- Step 1: account info.
- Step 2: passport upload.
- Step 3: verification message.
- Uploads passport image to Firebase Storage.
- Updates Firestore status to `under_verification`.

Known auth issues and cleanup items:

- There are two signup flows: regular signup and signup stepper. These should be consolidated.
- `SignupStepperController` uses `dart:io`, which may be problematic for web support.
- Forgot password exists, but should be verified end to end.
- Auth middleware only checks authentication, while deeper account status enforcement happens in login and home.

## Passport Feature

Implemented screens:

- Passport scan screen
- Passport manage / verification screen

Implemented controllers:

- `PassportScanController`
- `PassportManageController`
- `PassportUploadController`

Current passport upload behavior:

- User can upload a passport image from gallery.
- User can scan/take a passport photo with camera.
- Image uploads to Firebase Storage path:

```text
passports/{uid}.jpg
```

- Firestore account document is updated with:

```text
passportUrl
status: under_verification
passportUploadedAt
```

Current passport scan behavior:

- Requests camera permission.
- Initializes camera.
- Uses image picker/camera to capture an image.
- Uses Google ML Kit Text Recognition to extract text.
- Stores raw OCR text in `scannedText`.

What passport feature does not do yet:

- Does not parse MRZ.
- Does not validate passport number.
- Does not validate expiration date.
- Does not validate nationality/country fields.
- Does not compare passport photo to user identity.
- Does not call an external verification API.
- Does not provide admin approval tooling.
- Does not automatically set status to `verified`.
- Does not store extracted passport fields in a structured model.

Recommended next passport fields:

```text
passportNumber
passportCountry
passportNationality
passportGivenNames
passportSurname
passportDateOfBirth
passportExpiryDate
passportMrz
passportVerifiedAt
passportRejectedReason
verifiedBy
```

## Home Feature

Implemented:

- Welcome message.
- Current credits display.
- Placeholder recommendations section.
- Bottom navigation to map, profile, passport, and credits.
- Logout.

Home currently reads:

- User name from `accounts/{uid}.name`
- Credits from `accounts/{uid}.credits`

Home now blocks access unless the account status is `verified`.

What home does not do yet:

- No real recommendations.
- No live tourist activity summary.
- No warnings/sanctions display.
- No reservation summary.
- No transport ticket summary.
- No behavior score summary.

## Credits Feature

Implemented screens:

- Credit history
- Redemption

Implemented controller:

- `CreditController`

Current behavior:

- Uses in-memory placeholder data.
- Shows example history:
  - Initial Credits
  - Visited Historical Monument
  - Redeemed for Souvenir Discount
- Shows example redemption offers:
  - Souvenir discount
  - Free museum ticket

What credits feature does not do yet:

- No Firestore transaction history.
- No real credit ledger.
- No atomic credit updates.
- No behavior report integration.
- No sanctions.
- No admin/moderation flow.
- No real redemption fulfillment.
- No QR voucher or proof of redemption.

Recommended data model:

```text
accounts/{uid}
  credits
  status
  behaviorStatus

credit_transactions/{transactionId}
  userId
  amount
  type
  reason
  source
  createdAt
  createdBy
  relatedReportId
  relatedReservationId
```

Recommended transaction types:

- `entry_bonus`
- `good_behavior_reward`
- `place_visit_reward`
- `reservation_reward`
- `violation_penalty`
- `sanction_penalty`
- `redemption`
- `manual_adjustment`

## Behavior Reports And Sanctions

This feature is not implemented yet.

Needed flows:

- Report a tourist.
- Upload evidence.
- Admin/moderator review.
- Approve or reject report.
- Apply credit penalty if approved.
- Apply sanction if severe or repeated.
- Notify tourist.
- Allow appeal.

Recommended collections:

```text
behavior_reports/{reportId}
  reportedUserId
  reporterUserId
  reporterRole
  category
  description
  evidenceUrls
  location
  placeId
  status
  createdAt
  reviewedAt
  reviewedBy
  decision
  penaltyPoints

sanctions/{sanctionId}
  userId
  reportId
  type
  reason
  startAt
  endAt
  active
  createdAt
```

Potential sanction types:

- Warning
- Points penalty
- Reservation restriction
- Transport ticket restriction
- Temporary account suspension
- Manual authority review

## Map Feature

Implemented:

- Google Map screen.
- Map controller.
- Two hard-coded example markers in San Francisco.
- Refresh button.
- Zoom controls.
- Current location button currently animates to the initial hard-coded coordinate.

Current initial coordinate:

```text
37.7749, -122.4194
```

What map does not do yet:

- No real tourist places.
- No place database.
- No monument/museum/theater/colosseum registry.
- No opening hours.
- No crowd prediction.
- No reservation flow.
- No transport stations.
- No ticket buying.
- No payment integration.
- No user location integration, despite geolocator dependency.

Recommended place model:

```text
places/{placeId}
  name
  category
  description
  latitude
  longitude
  address
  city
  country
  openingHours
  closingDays
  images
  capacity
  ticketRequired
  ticketPrice
  reservationRequired
  rules
  popularityScore
  createdAt
  updatedAt
```

Recommended categories:

- Monument
- Museum
- Theater
- Colosseum
- Temple
- Castle
- Park
- Beach
- Historical site
- Famous place
- Public transport station

## ML Crowd Prediction

This feature is not implemented yet.

Desired behavior:

- Tourist selects a place.
- Tourist enters date/time.
- App predicts whether the place will be crowded.
- App shows low, medium, or high crowd level.
- App uses prediction to help decide where to go.

Recommended first implementation:

Start with a deterministic/mock predictor service in Dart before real ML.

Inputs:

```text
placeId
selectedDateTime
weekday
hour
season
holidayFlag
placePopularityScore
historicalVisitCount
reservationCount
weatherCondition
```

Output:

```text
crowdScore: 0-100
crowdLevel: low | medium | high
confidence
explanation
```

Recommended future ML paths:

- Cloud Function or backend API serving a trained model.
- TensorFlow Lite model embedded in Flutter.
- Firebase ML/Vertex AI style backend, if the deployment target supports it.

## Reservations

This feature is not implemented yet.

Needed flow:

- User opens place detail.
- Selects date/time.
- Sees crowd prediction.
- Chooses ticket/reservation type.
- Confirms reservation.
- Pays if needed.
- Receives reservation confirmation and QR code.

Recommended collection:

```text
reservations/{reservationId}
  userId
  placeId
  selectedDateTime
  visitorCount
  status
  price
  paymentStatus
  qrCodeData
  createdAt
  cancelledAt
```

Reservation statuses:

- `pending_payment`
- `confirmed`
- `cancelled`
- `expired`
- `used`

## Public Transportation

This feature is not implemented yet.

Needed functionality:

- Show stations on map.
- Show nearby stations.
- Show routes and schedules.
- Buy transport tickets.
- Show active tickets.
- Validate tickets with QR code.

Recommended collections:

```text
transport_stations/{stationId}
  name
  type
  latitude
  longitude
  lines
  city

transport_tickets/{ticketId}
  userId
  stationId
  lineId
  ticketType
  validFrom
  validUntil
  status
  qrCodeData
  paymentId
```

Transport station types:

- Bus
- Metro
- Train
- Tram
- Ferry

## Payments

This feature is not implemented yet.

Possible payment providers:

- Stripe
- PayPal
- Local provider based on target country
- Mock payments for prototype/demo

Recommended first step:

Implement mock payments first to unblock reservation and ticket flows.

Recommended collection:

```text
payments/{paymentId}
  userId
  amount
  currency
  provider
  providerPaymentId
  status
  purpose
  relatedReservationId
  relatedTicketId
  createdAt
  paidAt
```

Payment statuses:

- `pending`
- `paid`
- `failed`
- `refunded`
- `cancelled`

## Profile Feature

Implemented:

- Fetch profile name/email.
- Update profile form.

Current issue:

- Profile fetch reads from `accounts`.
- Profile update writes to `users`.

This should be normalized to use one collection, likely `accounts`.

Also, Firebase `updateEmail` is deprecated and should be replaced with `verifyBeforeUpdateEmail`.

## Core Services

Current core service files:

```text
lib/core/network/api_client.dart
lib/core/services/location_service.dart
lib/core/services/permission_service.dart
lib/data/datasources/local/local_storage.dart
```

These are mostly placeholders.

`InitialBinding` registers:

- `ApiClient`
- `LocationService`
- `PermissionService`
- `LocalStorage`

Current limitation:

- Services are minimal.
- API client does not define base URL/interceptors/auth handling.
- Location service has no implementation.
- Permission service likely needs full permission flow.

## Firebase Data Currently Used

Current known Firestore collection:

```text
accounts/{uid}
```

Known fields:

```text
name
email
status
createdAt
credits
passportUrl
passportUploadedAt
passportNumber
passportExpiryDate
```

Firebase Storage path:

```text
passports/{uid}.jpg
```

Realtime Database rules currently deny all reads/writes:

```json
{
  "rules": {
    ".read": false,
    ".write": false
  }
}
```

The app appears to use Firestore more than Realtime Database.

## Analyzer Status

Command run:

```text
dart analyze lib
```

Result:

- No analyzer errors.
- Only info-level issues remain.

Known style/info issues:

- Route constants use uppercase names and trigger lowerCamelCase lint.
- Some public widgets lack key constructors.
- Several controllers use `print`.
- Some uses of `withOpacity` are deprecated.
- Profile uses deprecated `updateEmail`.
- `ForgotPasswordController.dart` filename is not lower snake case.

## Important Current Risks

1. Passport verification is not real yet.
   The app only uploads passport photos and waits for status changes.

2. There is no admin panel.
   Someone must manually update Firestore status to `verified` or `rejected`.

3. Credits are not a real ledger.
   Current credit history is placeholder data.

4. Map is demo-only.
   Current places are hard-coded sample markers.

5. Data layer is thin.
   Controllers talk directly to Firebase, which will become harder to maintain.

6. Web support may break in file upload flows.
   Some controllers use `dart:io File`, which is not supported on web.

7. Firestore security rules were not reviewed.
   App security needs proper rules for accounts, passports, reports, reservations, and payments.

## Recommended Implementation Roadmap

### Phase 1: Stabilize Auth And Passport Verification

Goals:

- One signup flow.
- Clear passport upload flow.
- Real account state machine.
- Admin/manual verification.

Tasks:

- Remove or merge duplicate signup screens.
- Use signup stepper as the main signup experience.
- Parse OCR text into passport fields.
- Add MRZ parser.
- Add passport expiry validation.
- Add Firestore fields for extracted passport metadata.
- Add admin screen or backend function to approve/reject passports.
- Store rejection reason.
- Let rejected users re-upload passport.
- Add Firestore security rules.

### Phase 2: Build Data Models And Repositories

Goals:

- Move Firebase logic out of UI controllers.
- Create reusable app data layer.

Tasks:

- Create `AccountModel`.
- Create `PassportModel`.
- Create `CreditTransactionModel`.
- Create `PlaceModel`.
- Create `ReservationModel`.
- Create `BehaviorReportModel`.
- Create `TransportStationModel`.
- Create repositories:
  - `AuthRepository`
  - `AccountRepository`
  - `PassportRepository`
  - `CreditRepository`
  - `PlaceRepository`
  - `ReservationRepository`
  - `ReportRepository`
  - `TransportRepository`

### Phase 3: Real Credits And Behavior System

Goals:

- Replace placeholder credits with a real transaction ledger.
- Add report and sanction workflows.

Tasks:

- Create `credit_transactions` collection.
- Implement atomic credit update service.
- Create report submission screen.
- Add report categories.
- Add evidence upload.
- Add admin report review.
- Apply point changes after review.
- Add sanction creation.
- Show tourist behavior status in profile/home.

### Phase 4: Places And Tourism Map

Goals:

- Replace hard-coded map markers with real places.
- Make the map useful for tourist decisions.

Tasks:

- Create places collection in Firestore.
- Seed initial places for target country/city.
- Add map marker categories.
- Add place list/search.
- Add place detail screen.
- Add opening hours.
- Add place rules.
- Add image gallery.
- Add "open now" and "near me" filters.

### Phase 5: Crowd Prediction

Goals:

- Add ML-powered decision support.

Tasks:

- Build a first mock crowd predictor.
- Add date/time selector on place detail.
- Show predicted crowd level.
- Add crowd indicator to map markers.
- Store historical reservation/visit data.
- Later replace mock logic with trained backend model.

### Phase 6: Reservations

Goals:

- Let tourists reserve places online.

Tasks:

- Add availability/time slot model.
- Add reservation creation flow.
- Add QR confirmation.
- Add reservation history.
- Add cancellation flow.
- Connect reservations to crowd prediction data.

### Phase 7: Transport

Goals:

- Show transport stations and sell tickets.

Tasks:

- Add transport station collection.
- Show stations on map.
- Add station detail screen.
- Add ticket type model.
- Add ticket purchase flow.
- Add active ticket screen.
- Add QR ticket generation.

### Phase 8: Payments

Goals:

- Support reservations and transport ticket purchases.

Tasks:

- Add mock payment first.
- Add payment collection.
- Add payment status tracking.
- Add real provider later.
- Connect payment success to reservation/ticket confirmation.

### Phase 9: Quality, Security, And Testing

Goals:

- Make the app maintainable and safer.

Tasks:

- Add unit tests for repositories.
- Add controller tests.
- Add widget tests for auth/passport flow.
- Add Firestore security rules.
- Replace `print` with logger.
- Clean analyzer warnings.
- Improve error/loading/empty states.
- Add localization if needed.

## Suggested Immediate Next Step

The best next implementation step is:

```text
Consolidate signup into one flow and implement MRZ passport parsing.
```

Why:

- The passport gate is now in place.
- The app needs a real way to decide whether a passport is valid.
- Once passport data is structured, admin approval, initial points, and user trust level become easier to implement.

