/**
 * Basic TypeScript interfaces for Circuit Copilot (Sprint 0)
 */

export interface TicketInfo {
  gate: string;
  zone: string;
  seat: string;
  seat_coordinates: [number, number];
}

export interface UserTicketSyncResponse {
  user_id: string;
  token: string;
  ticket_info: TicketInfo;
}

export type POICategory = 'toilet' | 'food' | 'gate' | 'medical' | 'parking';

export interface POI {
  id: number;
  name: string;
  category: POICategory;
  coordinates: [number, number];
}
