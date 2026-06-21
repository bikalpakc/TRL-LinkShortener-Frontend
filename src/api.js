const BASE_URL = import.meta.env.VITE_API_URL || "";

export const API_ENDPOINTS = {
    LOGIN: `${BASE_URL}/api/users/login/`,
    REGISTER: `${BASE_URL}/api/users/register/`,
    LINKS: `${BASE_URL}/api/links/`,
    ANALYTICS: `${BASE_URL}/api/analytics/`, //{short_code}/ and {short_code}/summary/ will be appended in LinkDetails.jsx
    // We can add other endpoints here...
};

export default BASE_URL;