// Auto-generated types from Supabase schema.
// Regenerar con: npx supabase gen types typescript --local > lib/supabase/types.ts

export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[]

export interface Database {
  public: {
    Tables: {
      orgs: {
        Row: {
          id: string
          name: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          created_at?: string
        }
      }
      org_members: {
        Row: {
          org_id: string
          user_id: string
          role: 'admin' | 'member'
          created_at: string
        }
        Insert: {
          org_id: string
          user_id: string
          role?: 'admin' | 'member'
          created_at?: string
        }
        Update: {
          org_id?: string
          user_id?: string
          role?: 'admin' | 'member'
          created_at?: string
        }
      }
      brands: {
        Row: {
          id: string
          org_id: string
          name: string
          website: string | null
          category: string | null
          ticket_avg_cents: number | null
          description: string | null
          description_embedding: number[] | null
          target_audience: Json | null
          brand_voice: string | null
          created_at: string
        }
        Insert: {
          id?: string
          org_id: string
          name: string
          website?: string | null
          category?: string | null
          ticket_avg_cents?: number | null
          description?: string | null
          description_embedding?: number[] | null
          target_audience?: Json | null
          brand_voice?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          org_id?: string
          name?: string
          website?: string | null
          category?: string | null
          ticket_avg_cents?: number | null
          description?: string | null
          description_embedding?: number[] | null
          target_audience?: Json | null
          brand_voice?: string | null
          created_at?: string
        }
      }
      campaigns: {
        Row: {
          id: string
          brand_id: string
          name: string
          objective: 'awareness' | 'sales' | 'traffic' | 'positioning' | 'launch' | 'engagement' | null
          budget_cents: number | null
          countries: string[] | null
          platforms: string[] | null
          status: string
          brief: Json | null
          created_at: string
        }
        Insert: {
          id?: string
          brand_id: string
          name: string
          objective?: 'awareness' | 'sales' | 'traffic' | 'positioning' | 'launch' | 'engagement' | null
          budget_cents?: number | null
          countries?: string[] | null
          platforms?: string[] | null
          status?: string
          brief?: Json | null
          created_at?: string
        }
        Update: {
          id?: string
          brand_id?: string
          name?: string
          objective?: 'awareness' | 'sales' | 'traffic' | 'positioning' | 'launch' | 'engagement' | null
          budget_cents?: number | null
          countries?: string[] | null
          platforms?: string[] | null
          status?: string
          brief?: Json | null
          created_at?: string
        }
      }
      creators: {
        Row: {
          id: string
          handle: string
          platform: 'tiktok' | 'instagram' | 'youtube'
          follower_count: number | null
          engagement_rate: number | null
          fake_follower_pct: number | null
          niche: string[] | null
          country: string | null
          audience_demo: Json | null
          content_embedding: number[] | null
          avatar_initials: string | null
          created_at: string
        }
        Insert: {
          id?: string
          handle: string
          platform: 'tiktok' | 'instagram' | 'youtube'
          follower_count?: number | null
          engagement_rate?: number | null
          fake_follower_pct?: number | null
          niche?: string[] | null
          country?: string | null
          audience_demo?: Json | null
          content_embedding?: number[] | null
          avatar_initials?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          handle?: string
          platform?: 'tiktok' | 'instagram' | 'youtube'
          follower_count?: number | null
          engagement_rate?: number | null
          fake_follower_pct?: number | null
          niche?: string[] | null
          country?: string | null
          audience_demo?: Json | null
          content_embedding?: number[] | null
          avatar_initials?: string | null
          created_at?: string
        }
      }
      matches: {
        Row: {
          id: string
          campaign_id: string | null
          creator_id: string | null
          score: number | null
          score_breakdown: Json | null
          recommended_brief: Json | null
          status: string
          fee_estimate_cents: number | null
          campaign_recommendation: string | null
          created_at: string
        }
        Insert: {
          id?: string
          campaign_id?: string | null
          creator_id?: string | null
          score?: number | null
          score_breakdown?: Json | null
          recommended_brief?: Json | null
          status?: string
          fee_estimate_cents?: number | null
          campaign_recommendation?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          campaign_id?: string | null
          creator_id?: string | null
          score?: number | null
          score_breakdown?: Json | null
          recommended_brief?: Json | null
          status?: string
          fee_estimate_cents?: number | null
          campaign_recommendation?: string | null
          created_at?: string
        }
      }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: Record<string, never>
  }
}
