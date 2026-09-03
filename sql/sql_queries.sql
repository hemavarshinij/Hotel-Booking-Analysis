CREATE TABLE hotel_bookings (
    hotel TEXT,
    is_canceled INTEGER,
    lead_time INTEGER,
    arrival_date_year INTEGER,
    arrival_date_month TEXT,
    arrival_date_week_number INTEGER,
    arrival_date_day_of_month INTEGER,
    stays_in_weekend_nights INTEGER,
    stays_in_week_nights INTEGER,
    adults INTEGER,
    children NUMERIC,
    babies INTEGER,
    meal TEXT,
    country TEXT,
    market_segment TEXT,
    distribution_channel TEXT,
    is_repeated_guest INTEGER,
    previous_cancellations INTEGER,
    previous_bookings_not_canceled INTEGER,
    reserved_room_type TEXT,
    assigned_room_type TEXT,
    booking_changes INTEGER,
    deposit_type TEXT,
    agent TEXT,
    days_in_waiting_list INTEGER,
    customer_type TEXT,
    adr NUMERIC,
    required_car_parking_spaces INTEGER,
    total_of_special_requests INTEGER,
    reservation_status TEXT,
    reservation_status_date DATE,
    total_guests NUMERIC,
    stay_nights INTEGER,
    booking_status TEXT,
    arrival_date DATE,
    lead_time_category TEXT
);

SELECT COUNT(*) AS number_of_columns
FROM information_schema.columns
WHERE table_name = 'hotel_bookings';

SELECT COUNT(*) AS total_rows
FROM hotel_bookings;

SELECT *
FROM hotel_bookings
LIMIT 10;

SELECT
    hotel,
    COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY hotel;

----1. Highest Cancellation Percentage----

SELECT
    hotel,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(
        SUM(is_canceled) * 100.0 / COUNT(*),
        2
    ) AS cancellation_percentage
FROM hotel_bookings
GROUP BY hotel
ORDER BY cancellation_percentage DESC;


----2. Months with Highest Bookings----

SELECT
    arrival_date_month,
    COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY arrival_date_month
ORDER BY total_bookings DESC;


----3. Customer types with the highest average ADR----

SELECT
    customer_type,
    ROUND(AVG(adr), 2) AS average_adr
FROM hotel_bookings
GROUP BY customer_type
ORDER BY average_adr DESC;


----4. Lead Time vs Cancellation----

SELECT
    lead_time_category,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(
        SUM(is_canceled) * 100.0 / COUNT(*),
        2
    ) AS cancellation_percentage
FROM
(
    SELECT
        lead_time,
        is_canceled,
        CASE
            WHEN lead_time BETWEEN 0 AND 30 THEN '0-30 Days'
            WHEN lead_time BETWEEN 31 AND 90 THEN '31-90 Days'
            WHEN lead_time BETWEEN 91 AND 180 THEN '91-180 Days'
            ELSE '>180 Days'
        END AS lead_time_category
    FROM hotel_bookings
) AS categorized_bookings
GROUP BY lead_time_category
ORDER BY cancellation_percentage DESC;


----5. Top 5 Countries Generating Completed Bookings----

SELECT
    country,
    COUNT(*) AS completed_bookings
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY country
ORDER BY completed_bookings DESC
LIMIT 5;